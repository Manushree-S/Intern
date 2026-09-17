import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

abstract class CrashlyticsService {
  Future<void> log(String message);
  Future<void> recordError(dynamic exception, StackTrace? stack, {dynamic reason, bool fatal = false});
  Future<void> setUserId(String userId);
  Future<void> setCustomKey(String key, Object value);
}

class CrashlyticsServiceImpl implements CrashlyticsService {
  final FirebaseCrashlytics? _crashlytics;

  CrashlyticsServiceImpl({FirebaseCrashlytics? crashlytics})
      : _crashlytics = crashlytics;

  @override
  Future<void> log(String message) async {
    if (kDebugMode) {
      debugPrint('[Crashlytics Log]: $message');
      return;
    }
    await _crashlytics?.log(message);
  }

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    bool fatal = false,
  }) async {
    if (kDebugMode) {
      debugPrint('[Crashlytics Error]: $exception\nReason: $reason\nStack: $stack');
      return;
    }
    await _crashlytics?.recordError(exception, stack, reason: reason, fatal: fatal);
  }

  @override
  Future<void> setUserId(String userId) async {
    if (kDebugMode) return;
    await _crashlytics?.setUserIdentifier(userId);
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    if (kDebugMode) return;
    await _crashlytics?.setCustomKey(key, value);
  }
}
