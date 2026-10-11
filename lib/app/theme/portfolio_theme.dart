import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'portfolio_buttons.dart';
import 'portfolio_colors.dart';

abstract final class PortfolioTheme {
  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: PortfolioColors.background,
      colorScheme: const ColorScheme.dark(
        surface: PortfolioColors.background,
        primary: PortfolioColors.accent,
        onPrimary: PortfolioColors.background,
        secondary: PortfolioColors.textSecondary,
        onSurface: PortfolioColors.textPrimary,
        outline: PortfolioColors.divider,
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.ibmPlexSansTextTheme(base.textTheme).apply(
        bodyColor: PortfolioColors.textPrimary,
        displayColor: PortfolioColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      dividerTheme: const DividerThemeData(
        color: PortfolioColors.divider,
        thickness: 1,
        space: 1,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: PortfolioColors.accent,
        selectionColor: PortfolioColors.accentSoft,
        selectionHandleColor: PortfolioColors.accent,
      ),
      focusColor: PortfolioColors.accentSoft,
      hoverColor: PortfolioColors.accentSoft,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      primaryTextTheme: base.textTheme.apply(
        bodyColor: PortfolioColors.textPrimary,
        displayColor: PortfolioColors.textPrimary,
      ),
      filledButtonTheme: FilledButtonThemeData(style: PortfolioButtons.primary()),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: PortfolioButtons.primary(),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: PortfolioButtons.secondary(),
      ),
      textButtonTheme: TextButtonThemeData(style: PortfolioButtons.text()),
    );
  }
}

/// Prefetch fonts without blocking app startup indefinitely.
Future<void> preloadPortfolioFonts({
  Duration timeout = const Duration(seconds: 2),
}) async {
  try {
    await GoogleFonts.pendingFonts([
      GoogleFonts.manrope(),
      GoogleFonts.manrope(fontWeight: FontWeight.w600),
      GoogleFonts.manrope(fontWeight: FontWeight.w700),
      GoogleFonts.ibmPlexSans(),
      GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w500),
      GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w600),
      GoogleFonts.ibmPlexMono(),
    ]).timeout(timeout);
  } on TimeoutException {
    // Fall back to platform fonts; GoogleFonts will swap in when ready.
  } catch (_) {
    // Network or font failures must not prevent launch.
  }
}
