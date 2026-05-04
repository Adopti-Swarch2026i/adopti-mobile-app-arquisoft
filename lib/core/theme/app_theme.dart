import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const _borderRadius = 16.0;
  static const _buttonRadius = 12.0;

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
      titleMedium: GoogleFonts.nunitoSans(textStyle: baseTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      titleSmall: GoogleFonts.nunitoSans(textStyle: baseTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
      bodyLarge: GoogleFonts.nunitoSans(textStyle: baseTheme.bodyLarge),
      bodyMedium: GoogleFonts.nunitoSans(textStyle: baseTheme.bodyMedium),
      bodySmall: GoogleFonts.nunitoSans(textStyle: baseTheme.bodySmall),
      labelLarge: GoogleFonts.nunitoSans(textStyle: baseTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
      labelMedium: GoogleFonts.nunitoSans(textStyle: baseTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
      labelSmall: GoogleFonts.nunitoSans(textStyle: baseTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
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
          surfaceContainerHighest: AppColors.muted,
          error: AppColors.destructive,
          onError: Colors.white,
          tertiary: AppColors.accent,
          onTertiary: AppColors.accentForeground,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          backgroundColor: AppColors.backgroundLight,
          foregroundColor: AppColors.foregroundLight,
          titleTextStyle: TextStyle(
            fontFamily: 'Varela Round',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.foregroundLight,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryForeground,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.primaryForeground,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_buttonRadius),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_buttonRadius),
            ),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            foregroundColor: AppColors.primary,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.backgroundLight,
          indicatorColor: AppColors.primary.withValues(alpha: 0.1),
          elevation: 1,
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.primary);
            }
            return const IconThemeData(color: AppColors.foregroundLight);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12);
            }
            return const TextStyle(color: AppColors.foregroundLight, fontSize: 12);
          }),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.muted,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
            borderSide: const BorderSide(color: AppColors.destructive, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.muted,
          selectedColor: AppColors.primary.withValues(alpha: 0.15),
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFEAE8E4),
          thickness: 1,
          space: 1,
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_buttonRadius)),
          backgroundColor: AppColors.foregroundLight,
          contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          actionTextColor: Colors.white,
        ),
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          minVerticalPadding: 12,
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
          surfaceContainerHighest: Color(0xFF3A322C),
          error: AppColors.destructive,
          onError: Colors.white,
          tertiary: AppColors.accent,
          onTertiary: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          backgroundColor: AppColors.backgroundDark,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontFamily: 'Varela Round',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_buttonRadius),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_buttonRadius),
            ),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            foregroundColor: AppColors.primary,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.backgroundDark,
          indicatorColor: AppColors.primary.withValues(alpha: 0.2),
          elevation: 1,
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.primary);
            }
            return const IconThemeData(color: Colors.white70);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12);
            }
            return const TextStyle(color: Colors.white70, fontSize: 12);
          }),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF3A322C),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
            borderSide: const BorderSide(color: AppColors.destructive, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF3A322C),
          selectedColor: AppColors.primary.withValues(alpha: 0.25),
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF3A322C),
          thickness: 1,
          space: 1,
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_buttonRadius)),
          backgroundColor: AppColors.surfaceDark,
          contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          actionTextColor: Colors.white,
        ),
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          minVerticalPadding: 12,
        ),
      );
}
