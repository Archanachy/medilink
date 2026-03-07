import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:medilink/core/config/environment.dart';

/// WebSocket message model for consistency
class WebSocketMessage {
  final String type;
  final dynamic payload;
  final String? rawType;

  WebSocketMessage({
    required this.type,
    required this.payload,
    this.rawType,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'payload': payload,
  };

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      type: json['type'] ?? 'unknown',
      payload: json['payload'] ?? {},
    );
  }
}

enum WebSocketMessageType { 
  connect, 
  disconnect, 
  ping, 
  pong, 
  message, 
  error, 
  unknown 
}

/// Socket.IO based WebSocket service for real-time communication
/// Matches backend Socket.IO implementation exactly
class WebSocketService {
  WebSocketService._();
  static final WebSocketService instance = WebSocketService._();

  io.Socket? _socket;
  StreamController<WebSocketMessage>? _messageController;
  Timer? _reconnectTimer;
  Completer<void>? _connectCompleter;
  
  bool _isConnected = false;
  bool _isConnecting = false;
  bool _shouldReconnect = true;
  int _reconnectAttempts = 0;
  
  // Store connection details for reconnection
  String? _lastUserId;
  String? _lastToken;
  
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 5);

  /// Get message stream
  Stream<WebSocketMessage>? get messageStream => _messageController?.stream;

  /// Check if connected
  bool get isConnected => _isConnected;

  /// Connect to Socket.IO server
  /// Uses exact backend configuration: http://localhost:5050
  /// With transports: ["websocket", "polling"]
  /// Auth via token in auth handshake
  Future<void> connect(String userId, {String? token}) async {
    if (_isConnected) {
      if (kDebugMode) {
        debugPrint('⚠️ Socket.IO: Already connected');
      }
      return;
    }

    if (_isConnecting) {
      if (kDebugMode) {
        debugPrint('⚠️ Socket.IO: Connection already in progress, waiting...');
      }
      try {
        await _connectCompleter?.future.timeout(const Duration(seconds: 8));
      } catch (_) {}
      return;
    }

    // Disconnect any existing connection first
    if (_socket != null) {
      if (kDebugMode) {
        debugPrint('⚠️ Socket.IO: Disconnecting previous connection...');
      }
      await disconnect();
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Store for reconnection
    _lastUserId = userId;
    _lastToken = token;
    _shouldReconnect = true;

    _isConnecting = true;
    _connectCompleter = Completer<void>();
    _messageController ??= StreamController<WebSocketMessage>.broadcast();

    try {
      final socketUrl = Environment.baseUrl; // http://localhost:5050
      
      if (kDebugMode) {
        debugPrint('🔌 Socket.IO: Connecting to $socketUrl');
      }

      // Create Socket.IO client with exact backend configuration
      _socket = io.io(
        socketUrl,
        <String, dynamic>{
          // Match backend: transports: ["websocket", "polling"]
          'transports': ['websocket', 'polling'],
          'autoConnect': false, // Manual connection control
          'reconnection': false,
          'reconnectionDelay': 1000,
          'reconnectionDelayMax': 5000,
          'reconnectionAttempts': 5,
          // Auth: token in handshake (matches backend auth middleware)
          'auth': {
            'token': token ?? '',
          },
        },
      );

      // Connection successful
      _socket!.onConnect((_) {
        _isConnected = true;
        _isConnecting = false;
        _reconnectAttempts = 0;
        if (!(_connectCompleter?.isCompleted ?? true)) {
          _connectCompleter?.complete();
        }

        if (kDebugMode) {
          debugPrint('✅ Socket.IO: Connected successfully');
        }

        // Join user room (matches web frontend behavior)
        _socket!.emit('join_user_room', userId);
        
        if (kDebugMode) {
          debugPrint('📤 Socket.IO: Emitted join_user_room for user $userId');
        }
      });

      // Listen for any incoming events and broadcast them
      _socket!.onAny((event, data) {
        if (kDebugMode) {
          debugPrint('📥 Socket.IO: Received event=$event, data=$data');
        }

        // Convert to WebSocketMessage and broadcast
        final message = WebSocketMessage(
          type: WebSocketMessageType.message.toString().split('.').last,
          payload: data is Map ? data : {'data': data},
          rawType: event,
        );
        _messageController?.add(message);
      });

      // Handle connection errors
      _socket!.onError((error) {
        if (kDebugMode) {
          debugPrint('❌ Socket.IO: Error - $error');
        }
        _isConnected = false;
        _isConnecting = false;
        if (!(_connectCompleter?.isCompleted ?? true)) {
          _connectCompleter?.completeError(error ?? 'socket_error');
        }
        _scheduleReconnect(userId, token: token);
      });

      // Handle disconnect
      _socket!.onDisconnect((_) {
        _isConnected = false;
        _isConnecting = false;
        if (!(_connectCompleter?.isCompleted ?? true)) {
          _connectCompleter?.completeError('disconnected_before_connect');
        }

        if (kDebugMode) {
          debugPrint('🔌 Socket.IO: Disconnected');
        }

        if (_shouldReconnect && _reconnectAttempts < _maxReconnectAttempts) {
          _scheduleReconnect(userId, token: token);
        }
      });

      // Manually trigger connection
      _socket!.connect();

      await _connectCompleter!.future.timeout(const Duration(seconds: 8));

    } catch (e) {
      _isConnecting = false;
      _isConnected = false;

      if (kDebugMode) {
        debugPrint('❌ Socket.IO: Connection failed - $e');
      }

      _scheduleReconnect(userId, token: token);
      rethrow;
    }
  }

  /// Disconnect from Socket.IO server
  Future<void> disconnect() async {
    _shouldReconnect = false;
    _lastUserId = null;
    _lastToken = null;
    
    _reconnectTimer?.cancel();
    
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null;
    }
    
    _isConnected = false;
    _isConnecting = false;
    _connectCompleter = null;

    if (kDebugMode) {
      debugPrint('🔌 Socket.IO: Disconnected');
    }
  }

  /// Send message via Socket.IO emit
  void sendMessage(WebSocketMessage message) {
    if (!_isConnected || _socket == null) {
      if (kDebugMode) {
        debugPrint('⚠️ Socket.IO: Cannot send message - not connected');
      }
      return;
    }

    try {
      // Use rawType if available (for custom event names like chat:send)
      final eventName = message.rawType ?? message.type;

      _socket!.emitWithAck(
        eventName,
        message.payload,
        ack: (response) {
          if (kDebugMode) {
            debugPrint('✅ Socket.IO: Ack for $eventName - $response');
          }
          if (response is Map) {
            _messageController?.add(WebSocketMessage(
              type: '$eventName:response',
              payload: response,
              rawType: '$eventName:response',
            ));
          }
        },
      );
      
      if (kDebugMode) {
        debugPrint('📤 Socket.IO: Emitted $eventName with payload: $message.payload');
      }

      if (kDebugMode) {
        debugPrint('📤 Socket.IO: Message sent - $eventName');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Socket.IO: Failed to send message - $e');
      }
    }
  }

  /// Send custom event (for chat events like chat:send, chat:getHistory)
  /// Matches backend event handlers exactly
  void sendEvent(String event, Map<String, dynamic> payload) {
    if (!_isConnected || _socket == null) {
      if (kDebugMode) {
        debugPrint('⚠️ Socket.IO: Cannot send event - not connected');
      }
      return;
    }

    try {
      _socket!.emitWithAck(
        event,
        payload,
        ack: (response) {
          if (kDebugMode) {
            debugPrint('✅ Socket.IO: Ack for $event - $response');
          }
          if (response is Map) {
            _messageController?.add(WebSocketMessage(
              type: '$event:response',
              payload: response,
              rawType: '$event:response',
            ));
          }
        },
      );
      
      if (kDebugMode) {
        debugPrint('📤 Socket.IO: Emitted event $event with payload: $payload');
      }

      if (kDebugMode) {
        debugPrint('📤 Socket.IO: Event sent - $event with payload=$payload');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Socket.IO: Failed to send event $event - $e');
      }
    }
  }

  /// Schedule reconnection attempt
  void _scheduleReconnect(String? userId, {String? token}) {
    if (!_shouldReconnect || _reconnectAttempts >= _maxReconnectAttempts) {
      if (kDebugMode) {
        debugPrint('⚠️ Socket.IO: Max reconnect attempts reached or reconnect disabled');
      }
      return;
    }

    // Use stored credentials if not provided
    final reconnectUserId = userId ?? _lastUserId;
    final reconnectToken = token ?? _lastToken;
    
    if (reconnectUserId == null) {
      if (kDebugMode) {
        debugPrint('⚠️ Socket.IO: Cannot reconnect - no user ID available');
      }
      return;
    }

    _reconnectAttempts++;
    
    if (kDebugMode) {
      debugPrint('🔄 Socket.IO: Reconnecting in ${_reconnectDelay.inSeconds}s '
          '(attempt $_reconnectAttempts/$_maxReconnectAttempts)');
    }

    _reconnectTimer = Timer(_reconnectDelay, () {
      connect(reconnectUserId, token: reconnectToken);
    });
  }

  /// Dispose resources
  Future<void> dispose() async {
    await disconnect();
    await _messageController?.close();
    _messageController = null;
  }
}
