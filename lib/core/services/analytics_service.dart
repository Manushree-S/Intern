import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

abstract class AnalyticsService {
  Future<void> logScreenView({required String screenName, String? screenClass});
  Future<void> logEvent({required String name, Map<String, Object>? parameters});
  Future<void> setUserRole(String role);
}

class AnalyticsServiceImpl implements AnalyticsService {
  final FirebaseAnalytics? _analytics;

  AnalyticsServiceImpl({FirebaseAnalytics? analytics}) : _analytics = analytics;

  @override
  Future<void> logScreenView({required String screenName, String? screenClass}) async {
    if (kDebugMode) {
      debugPrint('[Analytics ScreenView]: $screenName');
      return;
    }
    await _analytics?.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );
  }

  @override
  Future<void> logEvent({required String name, Map<String, Object>? parameters}) async {
    if (kDebugMode) {
      debugPrint('[Analytics Event]: $name -> $parameters');
      return;
    }
    // COPPA Compliance: Strip any accidental PII before dispatching
    final sanitizedParams = parameters != null ? Map<String, Object>.from(parameters) : null;
    sanitizedParams?.removeWhere((key, _) =>
        key.toLowerCase().contains('email') ||
        key.toLowerCase().contains('phone') ||
        key.toLowerCase().contains('address'));

    await _analytics?.logEvent(name: name, parameters: sanitizedParams);
  }

  @override
  Future<void> setUserRole(String role) async {
    if (kDebugMode) return;
    await _analytics?.setUserProperty(name: 'user_role', value: role);
  }
}
