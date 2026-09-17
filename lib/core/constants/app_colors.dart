import 'package:flutter/material.dart';

/// Centralized color palette for [CLIENT NAME] EdTech application.
/// Provides high contrast and accessibility compliance for students and educators.
class AppColors {
  AppColors._();

  // Primary Institutional Blue Palette
  static const Color primaryBlue = Color(0xFF1E3A8A); // Deep Navy
  static const Color primaryBlueLight = Color(0xFF3B82F6);
  static const Color primaryBlueDark = Color(0xFF172554);

  // Secondary Accent Palette
  static const Color secondaryAmber = Color(0xFFD97706); // Warm Educational Amber
  static const Color secondaryAmberLight = Color(0xFFFBBF24);

  // Status & Feedback Colors
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color infoCyan = Color(0xFF06B6D4);

  // Neutral Colors (Light Theme)
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);

  // Neutral Colors (Dark Theme)
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color borderDark = Color(0xFF334155);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
}
