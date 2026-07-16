import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiKillSwitchService {
  final FirebaseRemoteConfig _remoteConfig;
  AiKillSwitchService(this._remoteConfig);

  static const _flagKey = 'ai_features_enabled';

  static Future<void> initialize(FirebaseRemoteConfig remoteConfig) async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval:
            kDebugMode ? Duration.zero : const Duration(minutes: 15),
      ),
    );
    await remoteConfig.setDefaults({_flagKey: true});
    unawaited(remoteConfig.fetchAndActivate());
  }

  bool get isAiEnabled => _remoteConfig.getBool(_flagKey);

  Future<void> refresh() async {
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (_) {
      // Best-effort: zuletzt bekannter/Default-Wert bleibt gültig.
    }
  }
}

final aiKillSwitchServiceProvider = Provider<AiKillSwitchService>(
  (ref) => AiKillSwitchService(FirebaseRemoteConfig.instance),
);
