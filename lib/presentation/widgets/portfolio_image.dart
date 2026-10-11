import 'package:flutter/material.dart';

import '../../app/theme/portfolio_colors.dart';
import '../../app/theme/portfolio_typography.dart';

/// Thin wrapper so image call sites stay consistent.
class PortfolioImage extends StatelessWidget {
  const PortfolioImage(
    this.assetPath, {
    super.key,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.width,
    this.height,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.errorBuilder,
    this.cacheWidth,
    this.cacheHeight,
  });

  final String assetPath;
  final BoxFit fit;
  final Alignment alignment;
  final double? width;
  final double? height;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final ImageErrorWidgetBuilder? errorBuilder;
  final int? cacheWidth;
  final int? cacheHeight;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final resolvedCacheWidth = cacheWidth ??
        (width != null ? (width! * dpr).round() : null);
    final resolvedCacheHeight = cacheHeight ??
        (height != null ? (height! * dpr).round() : null);

    return Image.asset(
      assetPath,
      fit: fit,
      alignment: alignment,
      width: width,
      height: height,
      cacheWidth: resolvedCacheWidth,
      cacheHeight: resolvedCacheHeight,
      filterQuality: FilterQuality.medium,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      errorBuilder: errorBuilder ??
          (context, error, stackTrace) => ColoredBox(
            color: PortfolioColors.surfaceElevated,
            child: Center(
              child: Text(
                'Image unavailable',
                style: PortfolioTypography.meta(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return ColoredBox(
          color: PortfolioColors.surface,
          child: child,
        );
      },
    );
  }
}
