import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:medilink/core/services/connectivity/network_info.dart';
import 'package:medilink/core/services/offline_queue/offline_queue_service.dart';

class OfflineStatusBanner extends StatefulWidget {
  const OfflineStatusBanner({super.key});

  @override
  State<OfflineStatusBanner> createState() => _OfflineStatusBannerState();
}

class _OfflineStatusBannerState extends State<OfflineStatusBanner> {
  final NetworkInfo _networkInfo = NetworkInfo(Connectivity());
  final OfflineQueueService _queueService = OfflineQueueService();
  bool _isOnline = true;
  int _pendingCount = 0;

  @override
  void initState() {
    super.initState();
    _checkStatus();
    // Check status every 5 seconds
    Future.delayed(const Duration(seconds: 5), _checkStatus);
  }

  Future<void> _checkStatus() async {
    if (!mounted) return;
    
    final isOnline = await _networkInfo.isConnected;
    final pendingCount = _queueService.getPendingCount();
    
    if (mounted) {
      setState(() {
        _isOnline = isOnline;
        _pendingCount = pendingCount;
      });
    }
    
    // Check again after 5 seconds
    Future.delayed(const Duration(seconds: 5), _checkStatus);
  }

  @override
  Widget build(BuildContext context) {
    // Don't show banner if online and no pending actions
    if (_isOnline && _pendingCount == 0) {
      return const SizedBox.shrink();
    }

    return Material(
      color: _isOnline ? Colors.orange.shade700 : Colors.red.shade700,
      child: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(
                _isOnline ? Icons.sync : Icons.cloud_off,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _isOnline
                      ? 'Syncing $_pendingCount pending action${_pendingCount != 1 ? 's' : ''}...'
                      : 'Offline Mode • $_pendingCount action${_pendingCount != 1 ? 's' : ''} pending',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (_pendingCount > 0 && !_isOnline)
                TextButton(
                  onPressed: () async {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Actions will sync automatically when you\'re back online',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Details',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
