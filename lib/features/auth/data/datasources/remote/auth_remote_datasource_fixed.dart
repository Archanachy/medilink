import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/core/api/api_endpoints.dart';
import 'package:medilink/core/services/storage/user_session_service.dart';
import 'package:medilink/features/auth/data/datasources/auth_datasource.dart';
import 'package:medilink/features/auth/data/models/auth_api_model.dart';


//create provider
final authRemoteDataSourceProvider = Provider<IAuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  })  : _apiClient = apiClient,
        _userSessionService = userSessionService;

  Map<String, dynamic> _extractUserData(Map<String, dynamic> data) {
    final user = data['user'];
    if (user is Map<String, dynamic>) {
      return user;
    }
    return data;
  }

  String? _extractAccessToken(Map<String, dynamic> data) {
    if (kDebugMode) {
      print('[TOKEN_EXTRACT] Called with keys: ${data.keys.toList()}');
    }
    
    // Try standard locations
    var token = data['token'] as String?;
    if (token != null && token.isNotEmpty) {
      if (kDebugMode) print('[TOKEN_EXTRACT] Found token in data[token]');
      return token;
    }
    
    token = data['accessToken'] as String?;
    if (token != null && token.isNotEmpty) {
      if (kDebugMode) print('[TOKEN_EXTRACT] Found token in data[accessToken]');
      return token;
    }
    
    token = data['access_token'] as String?;
    if (token != null && token.isNotEmpty) {
      if (kDebugMode) print('[TOKEN_EXTRACT] Found token in data[access_token]');
      return token;
    }
    
    // Check if token is nested in user object
    if (data['user'] is Map<String, dynamic>) {
      final user = data['user'] as Map<String, dynamic>;
      if (kDebugMode) print('[TOKEN_EXTRACT] Checking nested user object: ${user.keys.toList()}');
      
      token = user['token'] as String?;
      if (token != null && token.isNotEmpty) {
        if (kDebugMode) print('[TOKEN_EXTRACT] Found token in data[user][token]');
        return token;
      }
      
      token = user['accessToken'] as String?;
      if (token != null && token.isNotEmpty) {
        if (kDebugMode) print('[TOKEN_EXTRACT] Found token in data[user][accessToken]');
        return token;
      }
    }
    
    if (kDebugMode) {
      print('[TOKEN_EXTRACT] WARNING: Token not found in any expected location!');
      print('[TOKEN_EXTRACT] Full data structure: $data');
    }
    return null;
  }

  String? _extractRefreshToken(Map<String, dynamic> data) {
    return data['refreshToken'] as String? ??
        data['refresh_token'] as String?;
  }

  Future<void> _persistTokens(Map<String, dynamic> data) async {
    var token = _extractAccessToken(data);
    var refreshToken = _extractRefreshToken(data);

    if (kDebugMode) {
      print('[AUTH_PERSIST] Attempting to persist tokens');
      print('[AUTH_PERSIST] Token from _extractAccessToken: ${token != null ? 'YES (${token.substring(0, 20)}...)' : 'NO'}');
      print('[AUTH_PERSIST] RefreshToken: ${refreshToken != null ? 'YES' : 'NO'}');
      print('[AUTH_PERSIST] Full data keys: ${data.keys.toList()}');
    }

    // If not found in nested location, try top-level keys
    if (token == null || token.isEmpty) {
      token = data['token'] as String?;
      if (token != null && kDebugMode) {
        print('[AUTH_PERSIST] Found token at top-level data[token]');
      }
    }

    if (token != null && token.isNotEmpty) {
      await _secureStorage.write(key: 'auth_token', value: token);
      if (kDebugMode) print('[AUTH_PERSIST] ✅ Token saved to auth_token');
    } else {
      if (kDebugMode) print('[AUTH_PERSIST] ❌ WARNING: Token not found or empty!');
    }
    
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _secureStorage.write(key: 'refresh_token', value: refreshToken);
      if (kDebugMode) print('[AUTH_PERSIST] ✅ Refresh token saved');
    } else {
      if (kDebugMode) print('[AUTH_PERSIST] ℹ️ No refresh token to save');
    }
  }

  @override
  // ignore: no_leading_underscores_for_local_identifiers
  Future<AuthApiModel?> getUserById(String authId) {
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (kDebugMode) {
        print('[AUTH_LOGIN] Raw response keys: ${response.data.keys.toList()}');
        print('[AUTH_LOGIN] response.success: ${response.data['success']}');
        print('[AUTH_LOGIN] response.token exists: ${response.data.containsKey('token')}');
      }

      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>?;
        
        if (kDebugMode && data != null) {
          print('[AUTH_LOGIN] Nested data keys: ${data.keys.toList()}');
          print('[AUTH_LOGIN] Full data: $data');
        }
        
        if (data == null) {
          if (kDebugMode) print('[AUTH_LOGIN] WARNING: data is null');
          return null;
        }

        // Try to get token at top level first (from response.data['token'])
        String? topLevelToken = response.data['token'] as String?;
        
        // Then try to get from nested data
        final nestedToken = _extractAccessToken(data);
        
        // Use whichever we found
        final token = topLevelToken ?? nestedToken;
        
        if (kDebugMode) {
          print('[AUTH_LOGIN] Top-level token: ${topLevelToken != null ? 'YES' : 'NO'}');
          print('[AUTH_LOGIN] Nested token: ${nestedToken != null ? 'YES' : 'NO'}');
          print('[AUTH_LOGIN] Final token to use: ${token != null ? 'YES (${token.substring(0, 20)}...)' : 'NO'}');
        }
        
        final userData = _extractUserData(data);
        final extractedRefreshToken = _extractRefreshToken(data);
        
        final user = AuthApiModel.fromJson({
          ...userData,
          'token': token,
          'refreshToken': extractedRefreshToken,
        });

        // Persist tokens - pass the combined data with token at top level
        final persistData = {
          ...data,
          'token': token,  // Ensure token is at top level
          'refreshToken': extractedRefreshToken,
        };
        
        if (kDebugMode) print('[AUTH_LOGIN] Persisting tokens...');
        await _persistTokens(persistData);
        
        // Verify tokens were saved
        final savedToken = await _secureStorage.read(key: 'auth_token');
        if (kDebugMode) {
          print('[AUTH_LOGIN] Verified saved token: ${savedToken != null ? 'YES (${savedToken.substring(0, 20)}...)' : 'NO'}');
        }

        // Save to session
        await _userSessionService.saveUserSession(
          userId: user.id!,
          email: user.email,
          fullName: user.fullName,
          userName: user.userName,
          role: user.role,
          phoneNumber: user.phoneNumber,
          profilePicture: user.profilePicture ?? '',
        );

        if (kDebugMode) print('[AUTH_LOGIN] User session saved');

        return user;
      }
      
      if (kDebugMode) {
        print('[AUTH_LOGIN] Login failed: success was false');
        print('[AUTH_LOGIN] Message: ${response.data['message']}');
      }
      
      return null;
    } catch (e) {
      if (kDebugMode) print('[AUTH_LOGIN] Exception: $e');
      rethrow;
    }
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: user.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registeredUser = AuthApiModel.fromJson(data);
      return registeredUser;
    }
    return user;
  }

  @override
  Future<bool> forgotPassword(String email) async {
    final response = await _apiClient.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
    return response.data['success'] == true;
  }

  @override
  Future<bool> resetPassword(String token, String newPassword) async {
    final response = await _apiClient.post(
      ApiEndpoints.resetPassword,
      data: {
        'token': token,
        'newPassword': newPassword,
      },
    );
    return response.data['success'] == true;
  }

  @override
  Future<bool> verifyEmail(String token) async {
    final response = await _apiClient.post(
      ApiEndpoints.verifyEmail,
      data: {'token': token},
    );
    return response.data['success'] == true;
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    final response = await _apiClient.post(
      ApiEndpoints.refreshToken,
      data: {'refreshToken': refreshToken},
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final newToken = _extractAccessToken(data);
      if (newToken == null || newToken.isEmpty) {
        throw Exception('Token refresh failed');
      }
      
      final persistData = {
        ...data,
        'token': newToken,
      };
      await _persistTokens(persistData);
      return newToken;
    }
    throw Exception('Token refresh failed');
  }

  @override
  Future<AuthApiModel?> loginWithGoogle(String idToken) async {
    final response = await _apiClient.post(
      '/auth/google',
      data: {'idToken': idToken},
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final userData = _extractUserData(data);
      
      final token = response.data['token'] as String? ?? _extractAccessToken(data);
      
      final user = AuthApiModel.fromJson({
        ...userData,
        'token': token,
        'refreshToken': _extractRefreshToken(data),
      });

      final persistData = {
        ...data,
        'token': token,
      };
      await _persistTokens(persistData);

      // Save session
      await _userSessionService.saveUserSession(
        userId: user.id!,
        email: user.email,
        fullName: user.fullName,
        userName: user.userName,
        role: user.role,
        phoneNumber: user.phoneNumber,
        profilePicture: user.profilePicture ?? '',
      );

      return user;
    }
    return null;
  }

  @override
  Future<AuthApiModel?> loginWithApple(String authorizationCode) async {
    final response = await _apiClient.post(
      '/auth/apple',
      data: {'authorizationCode': authorizationCode},
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final userData = _extractUserData(data);
      
      final token = response.data['token'] as String? ?? _extractAccessToken(data);
      
      final user = AuthApiModel.fromJson({
        ...userData,
        'token': token,
        'refreshToken': _extractRefreshToken(data),
      });

      final persistData = {
        ...data,
        'token': token,
      };
      await _persistTokens(persistData);

      // Save session
      await _userSessionService.saveUserSession(
        userId: user.id!,
        email: user.email,
        fullName: user.fullName,
        userName: user.userName,
        role: user.role,
        phoneNumber: user.phoneNumber,
        profilePicture: user.profilePicture ?? '',
      );

      return user;
    }
    return null;
  }
}
