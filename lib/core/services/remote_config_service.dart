import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_keys.dart';

abstract class RemoteConfigService {
  Future<void> initialize();
  bool get isAutoEvaluationEnabled;
  bool get isLiveClassesEnabled;
  bool get isChatDoubtsEnabled;
  bool get isStudentPurchasesEnabled;
}

class RemoteConfigServiceImpl implements RemoteConfigService {
  final FirebaseRemoteConfig? _remoteConfig;

  RemoteConfigServiceImpl({FirebaseRemoteConfig? remoteConfig})
      : _remoteConfig = remoteConfig;

  @override
  Future<void> initialize() async {
    if (_remoteConfig == null) return;

    try {
      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: kDebugMode ? Duration.zero : const Duration(hours: 1),
        ),
      );

      // Safe defaults: All optional features disabled by default in v1
      await _remoteConfig!.setDefaults({
        AppKeys.flagAutoEvaluation: false,
        AppKeys.flagLiveClasses: false,
        AppKeys.flagChatDoubts: false,
        AppKeys.flagStudentPurchases: false,
      });

      await _remoteConfig!.fetchAndActivate();
    } catch (e) {
      debugPrint('[RemoteConfig] Warning: Failed to fetch remote config: $e');
    }
  }

  @override
  bool get isAutoEvaluationEnabled =>
      _remoteConfig?.getBool(AppKeys.flagAutoEvaluation) ?? false;

  @override
  bool get isLiveClassesEnabled =>
      _remoteConfig?.getBool(AppKeys.flagLiveClasses) ?? false;

  @override
  bool get isChatDoubtsEnabled =>
      _remoteConfig?.getBool(AppKeys.flagChatDoubts) ?? false;

  @override
  bool get isStudentPurchasesEnabled =>
      _remoteConfig?.getBool(AppKeys.flagStudentPurchases) ?? false;
}
