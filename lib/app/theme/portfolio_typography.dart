import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'portfolio_colors.dart';

/// Typography system: Manrope headlines, IBM Plex Sans body, IBM Plex Mono meta.
abstract final class PortfolioTypography {
  static TextStyle display(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final size = width >= 1100
        ? 88.0
        : width >= 720
        ? 64.0
        : 40.0;
    return GoogleFonts.manrope(
      fontSize: size,
      height: 1.05,
      letterSpacing: -1.6,
      fontWeight: FontWeight.w700,
      color: PortfolioColors.textPrimary,
    );
  }

  static TextStyle headlineLarge([BuildContext? context]) {
    final width = context != null ? MediaQuery.sizeOf(context).width : 1280.0;
    final size = width >= 1100
        ? 48.0
        : width >= 720
        ? 40.0
        : 32.0;
    return GoogleFonts.manrope(
      fontSize: size,
      height: 1.12,
      letterSpacing: -1.0,
      fontWeight: FontWeight.w700,
      color: PortfolioColors.textPrimary,
    );
  }

  static TextStyle headlineMedium([BuildContext? context]) {
    final width = context != null ? MediaQuery.sizeOf(context).width : 1280.0;
    final size = width >= 1100
        ? 36.0
        : width >= 720
        ? 30.0
        : 26.0;
    return GoogleFonts.manrope(
      fontSize: size,
      height: 1.18,
      letterSpacing: -0.7,
      fontWeight: FontWeight.w700,
      color: PortfolioColors.textPrimary,
    );
  }

  static TextStyle headlineSmall([BuildContext? context]) {
    final width = context != null ? MediaQuery.sizeOf(context).width : 1280.0;
    final size = width >= 720 ? 28.0 : 24.0;
    return GoogleFonts.manrope(
      fontSize: size,
      height: 1.22,
      letterSpacing: -0.4,
      fontWeight: FontWeight.w600,
      color: PortfolioColors.textPrimary,
    );
  }

  static TextStyle titleLarge() => GoogleFonts.manrope(
    fontSize: 22,
    height: 1.3,
    letterSpacing: -0.3,
    fontWeight: FontWeight.w600,
    color: PortfolioColors.textPrimary,
  );

  static TextStyle titleMedium() => GoogleFonts.manrope(
    fontSize: 18,
    height: 1.35,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w600,
    color: PortfolioColors.textPrimary,
  );

  static TextStyle bodyLarge() => GoogleFonts.ibmPlexSans(
    fontSize: 18,
    height: 1.65,
    fontWeight: FontWeight.w400,
    color: PortfolioColors.textSecondary,
  );

  static TextStyle body() => GoogleFonts.ibmPlexSans(
    fontSize: 17,
    height: 1.65,
    fontWeight: FontWeight.w400,
    color: PortfolioColors.textSecondary,
  );

  static TextStyle bodySmall() => GoogleFonts.ibmPlexSans(
    fontSize: 15,
    height: 1.55,
    fontWeight: FontWeight.w400,
    color: PortfolioColors.textSecondary,
  );

  static TextStyle label() => GoogleFonts.ibmPlexSans(
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: PortfolioColors.textPrimary,
  );

  static TextStyle meta() => GoogleFonts.ibmPlexMono(
    fontSize: 13,
    height: 1.45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    color: PortfolioColors.textMuted,
  );

  static TextStyle nav() => GoogleFonts.ibmPlexSans(
    fontSize: 14,
    height: 1.2,
    fontWeight: FontWeight.w500,
    color: PortfolioColors.textSecondary,
  );

  static TextStyle button() => GoogleFonts.ibmPlexSans(
    fontSize: 15,
    height: 1.2,
    fontWeight: FontWeight.w600,
    color: PortfolioColors.textPrimary,
  );
}
