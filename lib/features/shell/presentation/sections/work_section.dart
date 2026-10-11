import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/portfolio_colors.dart';
import '../../../../app/theme/portfolio_typography.dart';
import '../../../../core/constants/portfolio_constants.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/animations.dart';
import '../../../../core/utils/preview_assets.dart';
import '../../../../presentation/widgets/accent_rule.dart';
import '../../../../presentation/widgets/project_image_carousel.dart';
import '../../../../presentation/widgets/section_band.dart';
import '../../../portfolio/domain/entities/project.dart';

class WorkSection extends StatelessWidget {
  const WorkSection({
    super.key,
    required this.projects,
    this.onOpenProject,
    this.headingKey,
    this.headingFocusNode,
  });

  final List<Project> projects;
  final VoidCallback? onOpenProject;
  final Key? headingKey;
  final FocusNode? headingFocusNode;

  static const _featuredIds = {'asharq-business', 'asharq-now', 'rewardbee'};

  @override
  Widget build(BuildContext context) {
    final featured = projects
        .where((project) => _featuredIds.contains(project.id))
        .toList(growable: false);
    final remaining = projects
        .where((project) => !_featuredIds.contains(project.id))
        .toList(growable: false);

    return SectionBand(
      color: PortfolioColors.sectionBandB,
      child: PortfolioContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: context.isMobile ? 48 : 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AccentRule(horizontal: true),
              const SizedBox(height: 20),
              Focus(
                focusNode: headingFocusNode,
                child: Semantics(
                  header: true,
                  child: Text(
                    key: headingKey,
                    'Selected work',
                    style: PortfolioTypography.headlineLarge(context),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Text(
                  'Applications from my professional experience across financial news, streaming, rewards, communications and commerce. CodeWend is the consultancy I founded.',
                  style: PortfolioTypography.bodyLarge(),
                ),
              ),
              const SizedBox(height: 40),
              _ProjectGrid(
                projects: featured,
                featured: true,
                onOpen: (project) {
                  onOpenProject?.call();
                  context.go(AppRoutes.caseStudy(project.id));
                },
              ),
              if (remaining.isNotEmpty) ...[
                const SizedBox(height: 48),
                Text(
                  'More projects',
                  style: PortfolioTypography.headlineSmall(context),
                ),
                const SizedBox(height: 24),
                _ProjectGrid(
                  projects: remaining,
                  featured: false,
                  onOpen: (project) {
                    onOpenProject?.call();
                    context.go(AppRoutes.caseStudy(project.id));
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectGrid extends StatelessWidget {
  const _ProjectGrid({
    required this.projects,
    required this.featured,
    required this.onOpen,
  });

  final List<Project> projects;
  final bool featured;
  final ValueChanged<Project> onOpen;

  int _columns(BuildContext context) {
    if (context.isMobile && featured) {
      return 1;
    } else if (context.isMobile) {
      return 2;
    }
    if (context.isTablet && featured) return 3;
    if (context.isTablet) return 4;

    return featured ? 3 : 4;
  }

  @override
  Widget build(BuildContext context) {
    final columns = _columns(context);
    final gap = context.isMobile ? 20.0 : 24.0;

    if (columns == 1) {
      return Column(
        children: [
          for (final project in projects)
            Padding(
              padding: EdgeInsets.only(bottom: gap),
              child: _VerticalProjectCard(
                project: project,
                featured: featured,
                onOpen: () => onOpen(project),
              ),
            ),
        ],
      );
    }

    final rows = <Widget>[];
    for (var i = 0; i < projects.length; i += columns) {
      final slice = projects.skip(i).take(columns).toList();
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: gap),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var j = 0; j < columns; j++) ...[
                  if (j > 0) SizedBox(width: gap),
                  Expanded(
                    child: j < slice.length
                        ? _VerticalProjectCard(
                            project: slice[j],
                            featured: featured,
                            onOpen: () => onOpen(slice[j]),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

/// Portrait card built around phone-screen previews.
class _VerticalProjectCard extends StatefulWidget {
  const _VerticalProjectCard({
    required this.project,
    required this.featured,
    required this.onOpen,
  });

  final Project project;
  final bool featured;
  final VoidCallback onOpen;

  @override
  State<_VerticalProjectCard> createState() => _VerticalProjectCardState();
}

class _VerticalProjectCardState extends State<_VerticalProjectCard> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final active = _hovered || _focused;
    final project = widget.project;
    final featured = widget.featured;
    final gallery = _previewGallery(project, featured: featured);
    final images = gallery.map((item) => item.$1).toList(growable: false);

    // Phone-like stage: tall enough for mobile UI, restrained on narrow cards.
    final stageAspect = featured ? 9 / 16 : 9 / 14;
    final stageMaxHeight = featured
        ? (context.isMobile ? 520.0 : 560.0)
        : (context.isMobile ? 360.0 : 420.0);

    return AnimatedContainer(
      duration: PortfolioMotion.of(context, PortfolioMotion.micro),
      curve: motionEase,
      decoration: BoxDecoration(
        color: PortfolioColors.sectionBandA,
        border: Border.all(
          color: _focused
              ? PortfolioColors.focusRing
              : active
              ? PortfolioColors.accent.withValues(alpha: 0.45)
              : PortfolioColors.divider,
        ),
        borderRadius: BorderRadius.circular(PortfolioConstants.imageRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              featured ? 20 : 16,
              featured ? 20 : 16,
              featured ? 20 : 16,
              0,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: stageMaxHeight),
                child: AspectRatio(
                  aspectRatio: stageAspect,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ProjectImageCarousel(
                      images: images,
                      // Captions stay available for semantics via labels only.
                      captions: const [],
                      semanticLabelPrefix: '${project.name} preview',
                      fit: BoxFit.fitWidth,
                      backgroundColor: Colors.transparent,
                      showControls: featured && images.length > 1,
                      cacheWidth: featured ? 720 : 560,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Semantics(
            button: true,
            label: 'View ${project.name} case study',
            excludeSemantics: true,
            child: FocusableActionDetector(
              mouseCursor: SystemMouseCursors.click,
              onShowHoverHighlight: (value) => setState(() => _hovered = value),
              onShowFocusHighlight: (value) => setState(() => _focused = value),
              actions: <Type, Action<Intent>>{
                ActivateIntent: CallbackAction<ActivateIntent>(
                  onInvoke: (_) {
                    widget.onOpen();
                    return null;
                  },
                ),
              },
              shortcuts: const <ShortcutActivator, Intent>{
                SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
                SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
              },
              child: GestureDetector(
                onTap: widget.onOpen,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    featured ? 24 : 20,
                    featured ? 22 : 18,
                    featured ? 24 : 20,
                    featured ? 24 : 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.discipline.toUpperCase(),
                        style: PortfolioTypography.meta().copyWith(
                          color: PortfolioColors.accent,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        project.name,
                        style:
                            (featured
                                    ? PortfolioTypography.headlineSmall(context)
                                    : PortfolioTypography.titleMedium())
                                .copyWith(
                                  color: active
                                      ? PortfolioColors.accent
                                      : PortfolioColors.textPrimary,
                                ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        featured
                            ? project.shortDescription
                            : project.caseStudy.role,
                        style: PortfolioTypography.bodySmall(),
                        maxLines: featured ? 4 : 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (featured) ...[
                        const SizedBox(height: 12),
                        Text(
                          project.caseStudy.outcomeSummary,
                          style: PortfolioTypography.bodySmall().copyWith(
                            color: PortfolioColors.textPrimary,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<(String, String)> _previewGallery(
  Project project, {
  required bool featured,
}) {
  final annotations = project.caseStudy.designAnnotations;
  if (annotations.isNotEmpty) {
    final take = featured ? annotations.take(5) : annotations.take(1);
    return take
        .map((item) => (PreviewAssets.resolve(item.imageAsset), item.caption))
        .toList(growable: false);
  }

  final assets = project.imageAssets;
  if (assets.isEmpty) {
    return [(PreviewAssets.resolve(project.coverAsset), project.name)];
  }
  final take = featured ? assets.take(5) : assets.take(1);
  return take
      .map((asset) => (PreviewAssets.resolve(asset), project.name))
      .toList(growable: false);
}
