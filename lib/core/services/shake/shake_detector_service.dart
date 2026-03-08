import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetectorService {
  StreamSubscription<AccelerometerEvent>? _subscription;
  int _shakeCount = 0;
  Timer? _resetTimer;
  VoidCallback? _onShakeThresholdReached;
  bool _isDialogShowing = false;
  DateTime _lastShakeTime = DateTime.now();
  double _lastAcceleration = 0;
  bool _isShaking = false;

  static const int _shakeThreshold = 2;
  static const Duration _resetDuration = Duration(seconds: 3);
  static const double _shakeThresholdGravity = 15.0; // Higher threshold for actual shakes
  static const int _shakeIntervalMs = 800; // Minimum time between shake counts

  void initialize({required VoidCallback onShakeThresholdReached}) {
    _onShakeThresholdReached = onShakeThresholdReached;
    
    _subscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      final gX = event.x;
      final gY = event.y;
      final gZ = event.z;

      // Calculate total acceleration (remove gravity baseline ~9.8)
      final gForce = sqrt(gX * gX + gY * gY + gZ * gZ);
      
      // Calculate the delta from last reading
      final deltaAcceleration = (gForce - _lastAcceleration).abs();
      _lastAcceleration = gForce;

      // Detect a spike in acceleration (shake motion)
      if (deltaAcceleration > _shakeThresholdGravity && !_isShaking) {
        final now = DateTime.now();
        // Check if enough time has passed since last shake
        if (now.difference(_lastShakeTime).inMilliseconds > _shakeIntervalMs) {
          _isShaking = true;
          _lastShakeTime = now;
          _handleShake();
          
          // Reset shaking flag after a short delay to allow next shake
          Future.delayed(const Duration(milliseconds: 300), () {
            _isShaking = false;
          });
        }
      }
    });
  }

  void _handleShake() {
    // Cancel any existing reset timer
    _resetTimer?.cancel();

    _shakeCount++;
    debugPrint('Shake detected! Count: $_shakeCount/$_shakeThreshold');

    if (_shakeCount >= _shakeThreshold && !_isDialogShowing) {
      _isDialogShowing = true;
      _shakeCount = 0;
      _onShakeThresholdReached?.call();
    }

    // Reset shake count after duration
    _resetTimer = Timer(_resetDuration, () {
      _shakeCount = 0;
      debugPrint('Shake count reset');
    });
  }

  void resetDialogFlag() {
    _isDialogShowing = false;
  }

  void dispose() {
    _subscription?.cancel();
    _resetTimer?.cancel();
    _subscription = null;
    _onShakeThresholdReached = null;
  }

  bool get isDialogShowing => _isDialogShowing;
}
