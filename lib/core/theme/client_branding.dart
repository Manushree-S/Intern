import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Configurable branding model ensuring [CLIENT NAME] identity is modular and not hardcoded.
class ClientBranding {
  final String appName;
  final String institutionName;
  final Color primaryColor;
  final Color secondaryColor;
  final String? logoAssetPath;
  final String? logoNetworkUrl;
  final bool enableDarkMode;

  const ClientBranding({
    this.appName = '[CLIENT NAME] Learning',
    this.institutionName = 'Demo Educational Academy',
    this.primaryColor = AppColors.primaryBlue,
    this.secondaryColor = AppColors.secondaryAmber,
    this.logoAssetPath = 'assets/images/institution_logo.png',
    this.logoNetworkUrl,
    this.enableDarkMode = true,
  });

  ClientBranding copyWith({
    String? appName,
    String? institutionName,
    Color? primaryColor,
    Color? secondaryColor,
    String? logoAssetPath,
    String? logoNetworkUrl,
    bool? enableDarkMode,
  }) {
    return ClientBranding(
      appName: appName ?? this.appName,
      institutionName: institutionName ?? this.institutionName,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      logoAssetPath: logoAssetPath ?? this.logoAssetPath,
      logoNetworkUrl: logoNetworkUrl ?? this.logoNetworkUrl,
      enableDarkMode: enableDarkMode ?? this.enableDarkMode,
    );
  }
}
