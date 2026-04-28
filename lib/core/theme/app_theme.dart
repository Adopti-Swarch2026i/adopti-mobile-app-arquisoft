import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseTheme = brightness == Brightness.light
        ? GoogleFonts.nunitoSansTextTheme(ThemeData.light().textTheme)
        : GoogleFonts.nunitoSansTextTheme(ThemeData.dark().textTheme);

    return baseTheme.copyWith(
      displayLarge: GoogleFonts.varelaRound(textStyle: baseTheme.displayLarge),
      displayMedium: GoogleFonts.varelaRound(textStyle: baseTheme.displayMedium),
      displaySmall: GoogleFonts.varelaRound(textStyle: baseTheme.displaySmall),
      headlineLarge: GoogleFonts.varelaRound(textStyle: baseTheme.headlineLarge),
      headlineMedium: GoogleFonts.varelaRound(textStyle: baseTheme.headlineMedium),
      headlineSmall: GoogleFonts.varelaRound(textStyle: baseTheme.headlineSmall),
      titleLarge: GoogleFonts.varelaRound(textStyle: baseTheme.titleLarge),
      titleMedium: GoogleFonts.varelaRound(textStyle: baseTheme.titleMedium),
      titleSmall: GoogleFonts.varelaRound(textStyle: baseTheme.titleSmall),
    );
  }

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        textTheme: _buildTextTheme(Brightness.light),
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.primaryForeground,
          secondary: AppColors.secondary,
          onSecondary: AppColors.secondaryForeground,
          surface: Colors.white,
          onSurface: AppColors.foregroundLight,
          error: AppColors.destructive,
          onError: Colors.white,
          tertiary: AppColors.accent,
          onTertiary: AppColors.accentForeground,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.backgroundLight,
          foregroundColor: AppColors.foregroundLight,
          titleTextStyle: TextStyle(
            fontFamily: 'Varela Round',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.foregroundLight,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 1,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryForeground,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.primaryForeground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.backgroundLight,
          indicatorColor: AppColors.primary.withOpacity(0.1),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.primary);
            }
            return const IconThemeData(color: AppColors.foregroundLight);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600);
            }
            return const TextStyle(color: AppColors.foregroundLight);
          }),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        textTheme: _buildTextTheme(Brightness.dark),
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.surfaceDark,
          onSecondary: Colors.white70,
          surface: AppColors.surfaceDark,
          onSurface: Colors.white,
          background: AppColors.backgroundDark,
          onBackground: Colors.white,
          error: AppColors.destructive,
          onError: Colors.white,
          tertiary: AppColors.accent,
          onTertiary: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.backgroundDark,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontFamily: 'Varela Round',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 1,
          color: AppColors.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.backgroundDark,
          indicatorColor: AppColors.primary.withOpacity(0.2),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.primary);
            }
            return const IconThemeData(color: Colors.white70);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600);
            }
            return const TextStyle(color: Colors.white70);
          }),
        ),
      );
}
