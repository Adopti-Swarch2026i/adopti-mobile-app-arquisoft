import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary brand color
  static const Color primary = Color(0xFF358D64);
  static const Color primaryForeground = Color(0xFFFFFFFF);

  // Secondary
  static const Color secondary = Color(0xFFF6EEDF);
  static const Color secondaryForeground = Color(0xFF362417);

  // Backgrounds & Surfaces
  static const Color backgroundLight = Color(0xFFFDFDFC);
  static const Color foregroundLight = Color(0xFF362417);
  static const Color muted = Color(0xFFF8F6F2);

  // Accents
  static const Color accent = Color(0xFFDA732F);
  static const Color accentForeground = Color(0xFFFFFFFF);

  // Destructive / Warnings
  static const Color destructive = Color(0xFFEF4343);
  static const Color warning = Color(0xFFE5A040); // Approximated

  // Status Colors (from Web Design System)
  static const Color lost = Color(0xFFD72323);
  static const Color found = Color(0xFF32855F);
  static const Color reunited = Color(0xFFCB850B);

  // Dark Mode Overrides (approximated from CSS)
  static const Color backgroundDark = Color(0xFF1E1A17); // hsl(30, 20%, 10%)
  static const Color surfaceDark = Color(0xFF2A2420);    // hsl(30, 18%, 14%)
}
