import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../constants/portfolio_constants.dart';

enum PortfolioBreakpoint { mobile, tablet, desktop }

extension PortfolioBreakpointX on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  PortfolioBreakpoint get breakpoint {
    final width = screenWidth;
    if (width >= 1100) return PortfolioBreakpoint.desktop;
    if (width >= 720) return PortfolioBreakpoint.tablet;
    return PortfolioBreakpoint.mobile;
  }

  bool get isDesktop => breakpoint == PortfolioBreakpoint.desktop;
  bool get isTablet => breakpoint == PortfolioBreakpoint.tablet;
  bool get isMobile => breakpoint == PortfolioBreakpoint.mobile;

  double get pageGutter {
    return switch (breakpoint) {
      PortfolioBreakpoint.desktop => PortfolioSpacing.pageGutterDesktop,
      PortfolioBreakpoint.tablet => PortfolioSpacing.pageGutterTablet,
      PortfolioBreakpoint.mobile => PortfolioSpacing.pageGutterMobile,
    };
  }
}

class PortfolioContainer extends StatelessWidget {
  const PortfolioContainer({
    super.key,
    required this.child,
    this.maxWidth = PortfolioConstants.maxContentWidth,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = math.min(constraints.maxWidth, maxWidth);
        return Align(
          alignment: alignment,
          child: SizedBox(
            width: width,
            child: Padding(
              padding: padding ??
                  EdgeInsets.symmetric(horizontal: context.pageGutter),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
