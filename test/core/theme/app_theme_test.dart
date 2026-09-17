import 'package:edtech_platform/core/constants/app_colors.dart';
import 'package:edtech_platform/core/theme/app_theme.dart';
import 'package:edtech_platform/core/theme/client_branding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme Tests', () {
    test('Light theme should apply branding primary color and Material 3', () {
      const customBranding = ClientBranding(
        appName: 'Custom Academy',
        primaryColor: Color(0xFF112233),
      );

      final theme = AppTheme.lightTheme(branding: customBranding);

      expect(theme.useMaterial3, true);
      expect(theme.colorScheme.primary, const Color(0xFF112233));
      expect(theme.scaffoldBackgroundColor, AppColors.backgroundLight);
    });

    test('Dark theme should apply dark surface and background colors', () {
      final theme = AppTheme.darkTheme();

      expect(theme.useMaterial3, true);
      expect(theme.scaffoldBackgroundColor, AppColors.backgroundDark);
      expect(theme.colorScheme.brightness, Brightness.dark);
    });
  });
}
