import 'package:flutter/material.dart';

import '../../app/theme/portfolio_colors.dart';
import '../../core/responsive/breakpoints.dart';

/// Thin blue accent rule — vertical spine on desktop, short mark on mobile.
class AccentRule extends StatelessWidget {
  const AccentRule({super.key, this.height = 120, this.horizontal = false});

  final double height;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final useHorizontal = horizontal || context.isMobile;
    if (useHorizontal) {
      return Container(width: 48, height: 2, color: PortfolioColors.accent);
    }
    return Container(width: 2, height: height, color: PortfolioColors.accent);
  }
}

class AccentSpine extends StatelessWidget {
  const AccentSpine({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AccentRule(horizontal: true),
          const SizedBox(height: 20),
          child,
        ],
      );
    }

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: PortfolioColors.accent, width: 2)),
      ),
      child: Padding(padding: const EdgeInsets.only(left: 28), child: child),
    );
  }
}
