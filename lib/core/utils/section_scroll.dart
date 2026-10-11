import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../constants/portfolio_constants.dart';
import 'animations.dart';

/// Pixel-accurate section scrolling that accounts for the fixed navbar.
abstract final class SectionScroll {
  /// Header area occupied once the navbar is in its scrolled resting state,
  /// plus reading clearance below it.
  static double headerClearance(BuildContext context) {
    final safeTop = MediaQuery.paddingOf(context).top;
    return PortfolioConstants.sectionScrollClearanceTotal(safeTop);
  }

  /// Active-section detection line: bottom edge of the scrolled navbar.
  static double activeSectionThreshold(BuildContext context) {
    final safeTop = MediaQuery.paddingOf(context).top;
    return PortfolioConstants.navOccupiedScrolled(safeTop) + 8;
  }

  /// Target scroll offset so [anchorKey] sits just below the scrolled navbar.
  static double destinationFor({
    required ScrollController controller,
    required GlobalKey anchorKey,
    required double headerClearance,
  }) {
    if (!controller.hasClients) return 0;
    final position = controller.position;
    final max = position.maxScrollExtent;

    final targetContext = anchorKey.currentContext;
    if (targetContext == null) return position.pixels.clamp(0.0, max);

    final targetBox = targetContext.findRenderObject() as RenderBox?;
    if (targetBox == null || !targetBox.hasSize) {
      return position.pixels.clamp(0.0, max);
    }

    final viewport = RenderAbstractViewport.maybeOf(targetBox);
    if (viewport != null) {
      // alignment 0.0 = pin the target's leading edge to the viewport top.
      final revealed = viewport.getOffsetToReveal(targetBox, 0.0);
      return (revealed.offset - headerClearance).clamp(0.0, max);
    }

    // Fallback when no abstract viewport is available.
    final scrollableState = Scrollable.maybeOf(targetContext);
    final viewportBox =
        scrollableState?.context.findRenderObject() as RenderBox?;
    if (viewportBox == null || !viewportBox.hasSize) {
      return position.pixels.clamp(0.0, max);
    }

    final targetTopGlobal = targetBox.localToGlobal(Offset.zero).dy;
    final viewportTopGlobal = viewportBox.localToGlobal(Offset.zero).dy;
    final targetInViewport = targetTopGlobal - viewportTopGlobal;
    final delta = targetInViewport - headerClearance;

    return (position.pixels + delta).clamp(0.0, max);
  }

  /// Animate (or jump) to [destination], respecting reduced motion.
  static Future<void> animateToOffset({
    required BuildContext context,
    required ScrollController controller,
    required double destination,
    Duration? duration,
    Curve curve = motionEase,
  }) async {
    if (!controller.hasClients) return;
    final max = controller.position.maxScrollExtent;
    final clamped = destination.clamp(0.0, max);
    final resolved =
        duration ?? PortfolioMotion.of(context, PortfolioMotion.sectionScroll);

    if (resolved == Duration.zero) {
      controller.jumpTo(clamped);
      return;
    }

    await controller.animateTo(clamped, duration: resolved, curve: curve);
  }

  static Future<void> animateToAnchor({
    required BuildContext context,
    required ScrollController controller,
    required GlobalKey anchorKey,
    Duration? duration,
    Curve curve = motionEase,
  }) {
    final destination = destinationFor(
      controller: controller,
      anchorKey: anchorKey,
      headerClearance: headerClearance(context),
    );
    return animateToOffset(
      context: context,
      controller: controller,
      destination: destination,
      duration: duration,
      curve: curve,
    );
  }

  static Future<void> animateToTop({
    required BuildContext context,
    required ScrollController controller,
    Duration? duration,
    Curve curve = motionEase,
  }) {
    return animateToOffset(
      context: context,
      controller: controller,
      destination: 0,
      duration: duration,
      curve: curve,
    );
  }
}
