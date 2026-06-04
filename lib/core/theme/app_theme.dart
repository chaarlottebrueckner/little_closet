import 'package:flutter/material.dart';

class LCColors {
  LCColors._();

  static const background = Color(0xFFFAFAFA);
  static const primary = Color(0xFFD4789C);
  static const accent = Color(0xFFE8A0BF);
  static const deep = Color(0xFF9B4F72);
  static const textDark = Color(0xFF1A1A1A);
  static const textMuted = Color(0xFF8A8A8A);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceGlass = Color.fromARGB(153, 255, 255, 255);
  static const surfaceWarm = Color(0xFFF5EEF2);
  static const border = Color(0xFFEDE0E8);

  static const gradientPink = LinearGradient(
    colors: [Color(0xFFE8A0BF), Color(0xFFD4789C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

}

class LCGlass {
  LCGlass._();

  static const double blurSigma = 45.0;

  static const Color sheetColor = Color.fromARGB(153, 255, 246, 250);

  static const Color borderColor = Color(0x73E8A0BF);
  static const double borderWidth = 1.0;

  static const shimmerDivider = LinearGradient(
    colors: [
      Color(0x00FFFFFF),
      Color(0x99E8A0BF),
      Color(0x66D4789C),
      Color(0x00FFFFFF),
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );
}

class LCTheme {
  LCTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: LCColors.primary,
        secondary: LCColors.accent,
        tertiary: LCColors.deep,
        surface: LCColors.surface,
        onPrimary: Colors.white,
        onSurface: LCColors.textDark,
      ),
      scaffoldBackgroundColor: LCColors.background,
      textTheme: _buildTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: LCColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: LCColors.textDark,
          letterSpacing: 1.5,
        ),
        iconTheme: IconThemeData(color: LCColors.textDark),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: LCColors.surface,
        selectedItemColor: LCColors.primary,
        unselectedItemColor: LCColors.textMuted,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LCColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontFamily: 'DMSans',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: LCColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: LCColors.border, width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: LCColors.background,
        selectedColor: LCColors.primary.withValues(alpha: 0.15),
        labelStyle: const TextStyle(
          fontFamily: 'DMSans',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: LCColors.textDark,
        ),
        side: const BorderSide(color: LCColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LCColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: LCColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: LCColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: LCColors.primary, width: 1.5),
        ),
        labelStyle: const TextStyle(fontFamily: 'DMSans', color: LCColors.textMuted),
        hintStyle: const TextStyle(fontFamily: 'DMSans', color: LCColors.textMuted),
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'SpaceGrotesk',
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: LCColors.textDark,
        letterSpacing: -1.0,
      ),
      displayMedium: TextStyle(
        fontFamily: 'SpaceGrotesk',
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: LCColors.textDark,
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        fontFamily: 'SpaceGrotesk',
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: LCColors.textDark,
        letterSpacing: -0.5,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'SpaceGrotesk',
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: LCColors.textDark,
        letterSpacing: -0.25,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'SpaceGrotesk',
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: LCColors.textDark,
        letterSpacing: -0.25,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'SpaceGrotesk',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: LCColors.textDark,
      ),
      titleLarge: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: LCColors.textDark,
      ),
      titleMedium: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: LCColors.textDark,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: LCColors.textDark,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: LCColors.textDark,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: LCColors.textDark,
      ),
      bodySmall: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: LCColors.textMuted,
      ),
      labelLarge: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      labelMedium: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontFamily: 'DMSans',
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.0,
        color: LCColors.textMuted,
      ),
    );
  }
}
