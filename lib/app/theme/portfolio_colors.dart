import 'package:flutter/material.dart';

/// Portfolio palette — graphite field with spare clear-blue accent.
abstract final class PortfolioColors {
  static const Color background = Color(0xFF121416);
  static const Color surface = Color(0xFF181B1F);
  static const Color surfaceElevated = Color(0xFF1E2228);

  /// Alternating full-bleed section bands (odd = base, even = a step lighter).
  static const Color sectionBandA = background;
  static const Color sectionBandB = Color(0xFF171A1E);

  static const Color textPrimary = Color(0xFFF5F5F0);
  static const Color textSecondary = Color(0xFFB4BAC3);
  /// Essential metadata — verified ≥4.5:1 on [background].
  static const Color textMuted = Color(0xFF949AA3);

  static const Color accent = Color(0xFF719BFF);
  static const Color accentHover = Color(0xFF8AAEFF);
  static const Color accentPressed = Color(0xFF5A84E8);
  static const Color accentSoft = Color(0x33719BFF);

  static const Color divider = Color(0xFF30343B);
  static const Color focusRing = Color(0xFF719BFF);

  static const Color imageScrim = Color(0x66121416);
  static const Color controlScrim = Color(0xCC121416);
}
