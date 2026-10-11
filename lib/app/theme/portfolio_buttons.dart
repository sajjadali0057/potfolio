import 'package:flutter/material.dart';

import 'portfolio_colors.dart';
import 'portfolio_typography.dart';

/// Shared interactive control tokens for the portfolio.
abstract final class PortfolioButtons {
  static const double height = 48;
  static const double radius = 4;
  static const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 24);
  static const Duration transition = Duration(milliseconds: 150);

  static ButtonStyle primary() {
    return ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(0, height)),
      padding: const WidgetStatePropertyAll(padding),
      elevation: const WidgetStatePropertyAll(0),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
      textStyle: WidgetStatePropertyAll(PortfolioTypography.button()),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return PortfolioColors.accent.withValues(alpha: 0.35);
        }
        if (states.contains(WidgetState.pressed)) {
          return PortfolioColors.accentPressed;
        }
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return PortfolioColors.accentHover;
        }
        return PortfolioColors.accent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return PortfolioColors.background.withValues(alpha: 0.55);
        }
        // Graphite on accent — verified accessible pairing (not white-on-blue).
        return PortfolioColors.background;
      }),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      side: const WidgetStatePropertyAll(BorderSide.none),
    );
  }

  static ButtonStyle secondary() {
    return ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(0, height)),
      padding: const WidgetStatePropertyAll(padding),
      elevation: const WidgetStatePropertyAll(0),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
      textStyle: WidgetStatePropertyAll(PortfolioTypography.button()),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return PortfolioColors.accentSoft;
        }
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return PortfolioColors.surfaceElevated;
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return PortfolioColors.textMuted;
        }
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused) ||
            states.contains(WidgetState.pressed)) {
          return PortfolioColors.accent;
        }
        return PortfolioColors.textPrimary;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        final color = states.contains(WidgetState.disabled)
            ? PortfolioColors.divider
            : states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.pressed)
            ? PortfolioColors.accent
            : PortfolioColors.divider;
        return BorderSide(color: color);
      }),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }

  static ButtonStyle text() {
    return ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(0, height)),
      padding: const WidgetStatePropertyAll(padding),
      elevation: const WidgetStatePropertyAll(0),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
      textStyle: WidgetStatePropertyAll(PortfolioTypography.button()),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return PortfolioColors.textMuted;
        }
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused) ||
            states.contains(WidgetState.pressed)) {
          return PortfolioColors.accent;
        }
        return PortfolioColors.accent;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return PortfolioColors.accentSoft;
        }
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return PortfolioColors.accentSoft.withValues(alpha: 0.35);
        }
        return Colors.transparent;
      }),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }
}
