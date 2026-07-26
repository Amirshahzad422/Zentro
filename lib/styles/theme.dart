import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ZentroTheme {
  static const Color background = Color(0xFFF6FAFE);
  static const Color primary = Color(0xFF000000);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF505F76);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFD6E3FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF0F4F8);
  static const Color surfaceContainerHigh = Color(0xFFE4E9ED);
  static const Color surfaceContainerHighest = Color(0xFFDFE3E7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFE4E9ED);
  static const Color onSecondaryContainer = Color(0xFF1D192B);
  static const Color onSurface = Color(0xFF171C1F);
  static const Color onSurfaceVariant = Color(0xFF45464D);
  static const Color error = Color(0xFFBA1A1A);
  static const Color outline = Color(0xFF76777D);
  static const Color outlineVariant = Color(0xFFC6C6CD);

  // Additional tailwind colors used
  static const Color tertiary = Color(0xFF000000);
  static const Color emerald = Color(0xFF10B981); // for discount badges
  static const Color amber = Color(0xFFF59E0B); // for hover states / star ratings
  static const Color slate900 = Color(0xFF0F172A); // some buttons
  static const Color slate300 = Color(0xFFCBD5E1); // some borders

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        surface: surfaceContainerLowest,
        onSurface: onSurface,
        error: error,
        outline: outline,
        outlineVariant: outlineVariant,
      ),
      scaffoldBackgroundColor: background,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.72,
          color: onPrimary,
        ),
        headlineMedium: GoogleFonts.montserrat(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.24,
          color: primary,
        ),
        titleLarge: GoogleFonts.montserrat( // headline-md-mobile
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.20,
          color: primary,
        ),
        bodyLarge: GoogleFonts.inter( // body-lg
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: onSurface,
        ),
        bodyMedium: GoogleFonts.inter( // body-base
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: onSurface,
        ),
        labelLarge: GoogleFonts.inter( // body-bold
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
        labelMedium: GoogleFonts.inter( // label-caps
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6, // 0.05em
          color: onSurface,
        ),
        labelSmall: GoogleFonts.inter( // label-sm
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: onSurfaceVariant,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceContainerLowest,
        foregroundColor: primary,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
    );
  }
}
