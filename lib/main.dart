import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/theme/client_branding.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. Load Environment Configuration
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      debugPrint('[Env] Notice: .env file not found or failed to load, continuing with system defaults: $e');
    }

    // 2. Initialize Firebase Core with Graceful Local Fallback
    try {
      await Firebase.initializeApp();
      // Setup Crashlytics fatal error hook in release/production
      if (!kDebugMode) {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      }
    } catch (e) {
      debugPrint('[Firebase] Warning: Firebase initialization skipped or failed (safe for offline/mock test): $e');
    }

    // 3. Dynamic Branding Initialization
    final branding = ClientBranding(
      appName: dotenv.env['APP_NAME'] ?? '[CLIENT NAME] Learning',
      institutionName: dotenv.env['CLIENT_INSTITUTION_ID'] ?? 'Institution Academy',
    );

    // 4. Launch Application in Root Riverpod ProviderScope
    runApp(
      ProviderScope(
        child: EdTechApp(branding: branding),
      ),
    );
  }, (error, stack) {
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } else {
      debugPrint('[ZonedGuarded Error]: $error\n$stack');
    }
  });
}
