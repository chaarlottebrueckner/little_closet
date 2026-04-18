import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LCColors {
  LCColors._();

  // Core Palette
  static const background = Color(0xFFFAFAFA);
  static const primary = Color(0xFFD4789C);     // Cool Mauve-Rosa
  static const accent = Color(0xFFE8A0BF);       // Lighter highlight
  static const deep = Color(0xFF9B4F72);          // Dark contrast
  static const chrome = Color(0xFFC0C0C0);        // Silver / metallic
  static const textDark = Color(0xFF1A1A1A);      // Almost black
  static const textMuted = Color(0xFF8A8A8A);     // Subtle text
  static const surface = Color(0xFFFFFFFF);       // Card surfaces
  static const surfaceGlass = Color.fromARGB(153, 255, 255, 255);  // Glassmorphism

  // Gradients
  static const gradientPink = LinearGradient(
    colors: [Color(0xFFE8A0BF), Color(0xFFD4789C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientChrome = LinearGradient(
    colors: [Color(0xFFE8E8E8), Color(0xFFC0C0C0), Color(0xFFD8D8D8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientSurface = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF5F0F3)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class LCGlass {
  LCGlass._();

  //maybe change here
  // Blur strength
  static const double blurSigma = 24.0;

  // Sheet background: warm white-pink tint
  static const Color sheetColor = Color.fromARGB(117, 255, 246, 250); // ~35% opacity

  // Border: soft pink shimmer
  static const Color borderColor = Color(0x73E8A0BF); // ~45% opacity
  static const double borderWidth = 1.0;

  // Shimmer divider gradient (fades to transparent white)
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
      colorScheme: ColorScheme.light(
        background: LCColors.background,
        primary: LCColors.primary,
        secondary: LCColors.accent,
        tertiary: LCColors.deep,
        surface: LCColors.surface,
        onPrimary: Colors.white,
        onBackground: LCColors.textDark,
        onSurface: LCColors.textDark,
      ),
      scaffoldBackgroundColor: LCColors.background,
      textTheme: _buildTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: LCColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: LCColors.textDark,
          letterSpacing: 1.5,
        ),
        iconTheme: const IconThemeData(color: LCColors.textDark),
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
          textStyle: GoogleFonts.dmSans(
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
          side: const BorderSide(color: Color(0xFFEDE0E8), width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: LCColors.background,
        selectedColor: LCColors.primary.withOpacity(0.15),
        labelStyle: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: LCColors.textDark,
        ),
        side: const BorderSide(color: Color(0xFFEDE0E8)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LCColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEDE0E8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEDE0E8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: LCColors.primary, width: 1.5),
        ),
        labelStyle: GoogleFonts.dmSans(color: LCColors.textMuted),
        hintStyle: GoogleFonts.dmSans(color: LCColors.textMuted),
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      // Display — Space Grotesk, bold futuristic headlines
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: LCColors.textDark,
        letterSpacing: -1.0,
      ),
      displayMedium: GoogleFonts.spaceGrotesk(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: LCColors.textDark,
        letterSpacing: -0.5,
      ),
      displaySmall: GoogleFonts.spaceGrotesk(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: LCColors.textDark,
        letterSpacing: -0.5,
      ),
      // Headlines
      headlineLarge: GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: LCColors.textDark,
        letterSpacing: -0.25,
      ),
      headlineMedium: GoogleFonts.spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: LCColors.textDark,
        letterSpacing: -0.25,
      ),
      headlineSmall: GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: LCColors.textDark,
      ),
      // Titles — DM Sans
      titleLarge: GoogleFonts.dmSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: LCColors.textDark,
      ),
      titleMedium: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: LCColors.textDark,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: LCColors.textDark,
        letterSpacing: 0.1,
      ),
      // Body
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: LCColors.textDark,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: LCColors.textDark,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: LCColors.textMuted,
      ),
      // Labels
      labelLarge: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      labelMedium: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.dmSans(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.0,
        color: LCColors.textMuted,
      ),
    );
  }
}
