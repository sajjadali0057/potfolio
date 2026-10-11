import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/portfolio_colors.dart';
import '../../app/theme/portfolio_typography.dart';
import '../../core/constants/portfolio_constants.dart';
import '../../core/routing/app_router.dart';
import '../../core/utils/animations.dart';
import '../../features/portfolio/domain/entities/project.dart';
import 'portfolio_image.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({
    super.key,
    required this.project,
    this.aspectRatio = 16 / 10,
    this.large = false,
  });

  final Project project;
  final double aspectRatio;
  final bool large;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;
  bool _focused = false;

  void _open() => context.go(AppRoutes.caseStudy(widget.project.id));

  @override
  Widget build(BuildContext context) {
    final active = _hovered || _focused;
    final titleStyle =
        (widget.large
                ? PortfolioTypography.headlineSmall()
                : PortfolioTypography.titleLarge())
            .copyWith(
              color: active ? PortfolioColors.accent : PortfolioColors.textPrimary,
            );

    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
      onShowHoverHighlight: (value) => setState(() => _hovered = value),
      onShowFocusHighlight: (value) => setState(() => _focused = value),
      child: GestureDetector(
        onTap: _open,
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: widget.aspectRatio,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _focused
                        ? PortfolioColors.focusRing
                        : PortfolioColors.divider,
                  ),
                  borderRadius: BorderRadius.circular(
                    PortfolioConstants.imageRadius,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    PortfolioConstants.imageRadius,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ColoredBox(
                        color: PortfolioColors.surface,
                        child: AnimatedScale(
                          scale: prefersReducedMotion(context)
                              ? 1
                              : active
                              ? 1.02
                              : 1,
                          duration: PortfolioMotion.of(
                            context,
                            PortfolioMotion.hover,
                          ),
                          curve: motionEase,
                          child: PortfolioImage(
                            widget.project.coverAsset,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const ColoredBox(
                                  color: PortfolioColors.surfaceElevated,
                                ),
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: active ? 0.08 : 0,
                        duration: const Duration(milliseconds: 280),
                        curve: motionEase,
                        child: const ColoredBox(color: PortfolioColors.accent),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              curve: motionEase,
              style: titleStyle,
              child: Text(widget.project.name),
            ),
            const SizedBox(height: 8),
            Text(
              widget.project.shortDescription,
              style: PortfolioTypography.body(),
            ),
            const SizedBox(height: 10),
            Text(widget.project.metaLine, style: PortfolioTypography.meta()),
          ],
        ),
      ),
    );
  }
}
