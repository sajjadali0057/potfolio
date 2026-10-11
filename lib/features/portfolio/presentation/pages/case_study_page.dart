import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/portfolio_buttons.dart';
import '../../../../app/theme/portfolio_colors.dart';
import '../../../../app/theme/portfolio_typography.dart';
import '../../../../core/constants/portfolio_constants.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/routing/home_scroll_memory.dart';
import '../../../../core/utils/animations.dart';
import '../../../../core/utils/section_scroll.dart';
import '../../../../presentation/widgets/project_image_carousel.dart';
import '../../../../presentation/widgets/accent_rule.dart';
import '../../../../presentation/widgets/portfolio_link.dart';
import '../../domain/entities/project.dart';
import '../cubit/case_study_cubit.dart';
import '../cubit/case_study_state.dart';

class CaseStudyPage extends StatefulWidget {
  const CaseStudyPage({super.key, required this.projectId});

  final String projectId;

  @override
  State<CaseStudyPage> createState() => _CaseStudyPageState();
}

class _CaseStudyPageState extends State<CaseStudyPage> {
  final _scrollController = ScrollController();
  final _keys = <CaseStudySection, GlobalKey>{
    for (final section in CaseStudySection.values) section: GlobalKey(),
  };
  bool _programmaticScroll = false;
  bool _navScrolled = false;
  int _scrollGeneration = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;
    final nextScrolled = _navScrolled
        ? offset >= PortfolioConstants.scrollExitThreshold
        : offset > PortfolioConstants.scrollEnterThreshold;
    if (nextScrolled != _navScrolled) {
      setState(() => _navScrolled = nextScrolled);
    }
    if (!_programmaticScroll) {
      _updateActiveSection();
    }
  }

  void _updateActiveSection() {
    final state = context.read<CaseStudyCubit>().state;
    if (state is! CaseStudyReady) return;

    final visible = state.project.caseStudy.visibleSections();
    final threshold = SectionScroll.activeSectionThreshold(context);
    var active = visible.first;

    for (final section in visible) {
      final box = _keys[section]?.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final dy = box.localToGlobal(Offset.zero).dy;
      if (dy <= threshold) {
        active = section;
      }
    }

    context.read<CaseStudyCubit>().setSection(active);
  }

  Future<void> _scrollTo(CaseStudySection section) async {
    final generation = ++_scrollGeneration;
    context.read<CaseStudyCubit>().setSection(section);
    final key = _keys[section];
    if (key?.currentContext == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || generation != _scrollGeneration) return;
        _scrollTo(section);
      });
      return;
    }

    _programmaticScroll = true;
    await SectionScroll.animateToAnchor(
      context: context,
      controller: _scrollController,
      anchorKey: key!,
    );

    if (!mounted || generation != _scrollGeneration) return;
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted || generation != _scrollGeneration) return;
    await SectionScroll.animateToAnchor(
      context: context,
      controller: _scrollController,
      anchorKey: key,
      duration: Duration.zero,
    );

    if (!mounted || generation != _scrollGeneration) return;
    _programmaticScroll = false;
    _updateActiveSection();
  }

  void _backToWork() {
    if (HomeScrollMemory.offset == null) {
      HomeScrollMemory.section = null;
    }
    context.go(AppRoutes.work);
  }

  Future<void> _discussProject() async {
    final uri = Uri(
      scheme: 'mailto',
      path: PortfolioConstants.email,
      queryParameters: {
        'subject': 'Project discussion via Sajjad Ali portfolio',
      },
    );
    final ok = await launchUrl(uri);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the email app.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final safeTop = PortfolioConstants.safeAreaTop(
      MediaQuery.paddingOf(context).top,
    );

    return Scaffold(
      backgroundColor: PortfolioColors.background,
      body: BlocBuilder<CaseStudyCubit, CaseStudyState>(
        builder: (context, state) {
          if (state is CaseStudyLoading) {
            return const Center(
              child: CircularProgressIndicator(color: PortfolioColors.accent),
            );
          }
          if (state is CaseStudyMissing) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Project not found',
                    style: PortfolioTypography.titleLarge(),
                  ),
                  const SizedBox(height: 16),
                  PortfolioLink(
                    label: 'Back to work',
                    href: AppRoutes.work,
                    onPressed: _backToWork,
                  ),
                ],
              ),
            );
          }
          if (state is! CaseStudyReady) {
            return const SizedBox.shrink();
          }

          final project = state.project;
          final study = project.caseStudy;
          final visible = study.visibleSections();
          final showHeroGallery = !_sameGalleryAsScreens(project);

          return Stack(
            children: [
              Positioned.fill(
                child: PrimaryScrollController(
                  controller: _scrollController,
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height:
                              PortfolioConstants.navOccupiedAtTop(safeTop) + 24,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: PortfolioContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              if (visible.contains(CaseStudySection.overview))
                                _OverviewBlock(
                                  project: project,
                                  showGallery: showHeroGallery,
                                  headingKey:
                                      _keys[CaseStudySection.overview],
                                ),
                              if (visible.contains(CaseStudySection.role)) ...[
                                const SizedBox(height: 56),
                                _StoryBlock(
                                  headingKey: _keys[CaseStudySection.role],
                                  title: CaseStudySection.role.heading,
                                  body: study.role,
                                ),
                              ],
                              if (visible.contains(
                                CaseStudySection.decisions,
                              )) ...[
                                const SizedBox(height: 56),
                                _DecisionsAndNotes(
                                  headingKey: _keys[CaseStudySection.decisions],
                                  decisions: study.decisions,
                                  learned: study.learned,
                                ),
                              ],
                              if (visible.contains(
                                CaseStudySection.screens,
                              )) ...[
                                const SizedBox(height: 56),
                                _DesignBlock(
                                  headingKey: _keys[CaseStudySection.screens],
                                  annotations: study.designAnnotations,
                                ),
                              ],
                              if (visible.contains(
                                CaseStudySection.outcome,
                              )) ...[
                                const SizedBox(height: 56),
                                _StoryBlock(
                                  headingKey: _keys[CaseStudySection.outcome],
                                  title: CaseStudySection.outcome.heading,
                                  body: study.outcomeDetail,
                                  footnote: study.contributionNote,
                                ),
                              ],
                              const SizedBox(height: 72),
                              _NextSteps(
                                nextProject: state.nextProject,
                                onDiscuss: _discussProject,
                                onBackToWork: _backToWork,
                              ),
                              const SizedBox(height: 96),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _CaseStudyNav(
                  projectName: project.name,
                  active: state.activeSection,
                  sections: visible,
                  scrolled: _navScrolled,
                  onSelect: _scrollTo,
                  onBackToWork: _backToWork,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  bool _sameGalleryAsScreens(Project project) {
    final annotations = project.caseStudy.designAnnotations;
    if (annotations.isEmpty || project.imageAssets.isEmpty) return false;
    if (annotations.length != project.imageAssets.length) return false;
    for (var i = 0; i < annotations.length; i++) {
      if (annotations[i].imageAsset != project.imageAssets[i]) return false;
    }
    return true;
  }
}

class _CaseStudyNav extends StatelessWidget {
  const _CaseStudyNav({
    required this.projectName,
    required this.active,
    required this.sections,
    required this.scrolled,
    required this.onSelect,
    required this.onBackToWork,
  });

  final String projectName;
  final CaseStudySection active;
  final List<CaseStudySection> sections;
  final bool scrolled;
  final ValueChanged<CaseStudySection> onSelect;
  final VoidCallback onBackToWork;

  @override
  Widget build(BuildContext context) {
    final safeTop = PortfolioConstants.safeAreaTop(
      MediaQuery.paddingOf(context).top,
    );
    final reduce = prefersReducedMotion(context);
    final gap = scrolled ? PortfolioConstants.navTopSpacing : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: safeTop),
        AnimatedContainer(
          duration: reduce
              ? Duration.zero
              : PortfolioMotion.of(context, PortfolioMotion.nav),
          curve: Curves.easeOutCubic,
          height: gap,
        ),
        AnimatedContainer(
          duration: reduce
              ? Duration.zero
              : PortfolioMotion.of(context, PortfolioMotion.nav),
          curve: Curves.easeOutCubic,
          color: PortfolioColors.background.withValues(
            alpha: scrolled ? 0.94 : 0.88,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: scrolled
                      ? PortfolioColors.divider
                      : PortfolioColors.divider.withValues(alpha: 0.35),
                ),
              ),
            ),
            child: PortfolioContainer(
              child: SizedBox(
                height: PortfolioConstants.navHeight,
                child: Row(
                  children: [
                    Flexible(
                      child: PortfolioLink(
                        label: '← Work',
                        href: AppRoutes.work,
                        style: PortfolioTypography.label(),
                        onPressed: onBackToWork,
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (!context.isMobile)
                      Flexible(
                        flex: 3,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Row(
                            children: [
                              for (var i = 0; i < sections.length; i++) ...[
                                if (i > 0) const SizedBox(width: 18),
                                PortfolioLink(
                                  label: sections[i].label,
                                  active: active == sections[i],
                                  onPressed: () => onSelect(sections[i]),
                                ),
                              ],
                            ],
                          ),
                        ),
                      )
                    else
                      PopupMenuButton<CaseStudySection>(
                        tooltip: 'Sections',
                        color: PortfolioColors.surfaceElevated,
                        onSelected: onSelect,
                        itemBuilder: (context) => [
                          for (final section in sections)
                            PopupMenuItem(
                              value: section,
                              child: Text(section.label),
                            ),
                        ],
                        child: ExcludeSemantics(
                          child: Text(
                            'Sections',
                            style: PortfolioTypography.nav(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OverviewBlock extends StatelessWidget {
  const _OverviewBlock({
    required this.project,
    required this.showGallery,
    this.headingKey,
  });

  final Project project;
  final bool showGallery;
  final GlobalKey? headingKey;

  @override
  Widget build(BuildContext context) {
    final study = project.caseStudy;
    final purpose = study.purpose.trim().isNotEmpty
        ? study.purpose
        : project.shortDescription;
    final contextLine = study.challenge.trim().isNotEmpty &&
            study.challenge.trim() != purpose.trim()
        ? study.challenge
        : null;

    return AnimatedReveal(
      child: AccentSpine(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(
                project.name,
                style: PortfolioTypography.headlineLarge(context),
              ),
            ),
            const SizedBox(height: 12),
            Text(project.metaLine, style: PortfolioTypography.meta()),
            const SizedBox(height: 28),
            Semantics(
              header: true,
              child: Text(
                key: headingKey,
                CaseStudySection.overview.heading,
                style: PortfolioTypography.headlineSmall(context),
              ),
            ),
            const SizedBox(height: 12),
            Text(purpose, style: PortfolioTypography.bodyLarge()),
            if (contextLine != null) ...[
              const SizedBox(height: 16),
              Text(contextLine, style: PortfolioTypography.body()),
            ],
            const SizedBox(height: 36),
            Wrap(
              spacing: 40,
              runSpacing: 24,
              children: [
                _MetaCell(
                  label: 'Delivered',
                  value: study.outcomeSummary.trim().isNotEmpty
                      ? study.outcomeSummary
                      : project.shortDescription,
                ),
                _MetaCell(label: 'Collaborators', value: study.collaborators),
                if (study.timeline.isNotEmpty)
                  _MetaCell(label: 'Timeline', value: study.timeline),
                _MetaCell(
                  label: 'Category',
                  value: project.discipline,
                ),
              ],
            ),
            if (showGallery) ...[
              const SizedBox(height: 40),
              AspectRatio(
                aspectRatio: context.isMobile ? 4 / 5 : 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    PortfolioConstants.imageRadius,
                  ),
                  child: ProjectImageCarousel(
                    images: project.galleryAssets.isNotEmpty
                        ? project.galleryAssets
                        : [project.coverAsset],
                    captions: project.caseStudy.designAnnotations
                        .map((a) => a.caption)
                        .toList(growable: false),
                    semanticLabelPrefix: '${project.name} screen',
                    fit: BoxFit.contain,
                    backgroundColor: PortfolioColors.surface,
                    cacheWidth: 1400,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetaCell extends StatelessWidget {
  const _MetaCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.isMobile ? double.infinity : 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: PortfolioTypography.meta()),
          const SizedBox(height: 8),
          Text(
            value,
            style: PortfolioTypography.bodySmall().copyWith(
              color: PortfolioColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryBlock extends StatelessWidget {
  const _StoryBlock({
    required this.title,
    required this.body,
    this.footnote,
    this.headingKey,
  });

  final String title;
  final String body;
  final String? footnote;
  final GlobalKey? headingKey;

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              key: headingKey,
              title,
              style: PortfolioTypography.headlineSmall(context),
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(body, style: PortfolioTypography.body()),
          ),
          if (footnote != null && footnote!.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Text(footnote!, style: PortfolioTypography.meta()),
            ),
          ],
        ],
      ),
    );
  }
}

class _DecisionsAndNotes extends StatelessWidget {
  const _DecisionsAndNotes({
    required this.decisions,
    required this.learned,
    this.headingKey,
  });

  final List<ProjectDecision> decisions;
  final List<String> learned;
  final GlobalKey? headingKey;

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              key: headingKey,
              CaseStudySection.decisions.heading,
              style: PortfolioTypography.headlineSmall(context),
            ),
          ),
          if (decisions.isNotEmpty) ...[
            const SizedBox(height: 24),
            ...decisions.map(
              (decision) => Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: PortfolioColors.accent, width: 2),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          decision.title,
                          style: PortfolioTypography.titleMedium(),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Choice: ${decision.choice}',
                          style: PortfolioTypography.body(),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Alternative: ${decision.alternative}',
                          style: PortfolioTypography.bodySmall(),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          decision.reasoning,
                          style: PortfolioTypography.body().copyWith(
                            color: PortfolioColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (learned.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...learned.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 8, right: 14),
                      color: PortfolioColors.accent,
                    ),
                    Expanded(
                      child: Text(item, style: PortfolioTypography.body()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DesignBlock extends StatelessWidget {
  const _DesignBlock({required this.annotations, this.headingKey});

  final List<DesignAnnotation> annotations;
  final GlobalKey? headingKey;

  @override
  Widget build(BuildContext context) {
    final images = annotations.map((a) => a.imageAsset).toList(growable: false);
    final captions = annotations.map((a) => a.caption).toList(growable: false);

    return ScrollReveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              key: headingKey,
              CaseStudySection.screens.heading,
              style: PortfolioTypography.headlineSmall(context),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Browse application screens and related artwork. Use Previous/Next, indicators, or arrow keys when focused.',
            style: PortfolioTypography.body(),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: context.isMobile ? 460 : 600,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(PortfolioConstants.imageRadius),
              child: ProjectImageCarousel(
                images: images,
                captions: captions,
                semanticLabelPrefix: 'Application screen',
                fit: BoxFit.contain,
                backgroundColor: PortfolioColors.surface,
                cacheWidth: 1400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextSteps extends StatelessWidget {
  const _NextSteps({
    required this.nextProject,
    required this.onDiscuss,
    required this.onBackToWork,
  });

  final Project? nextProject;
  final VoidCallback onDiscuss;
  final VoidCallback onBackToWork;

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: PortfolioColors.divider),
          borderRadius: BorderRadius.circular(PortfolioConstants.imageRadius),
          color: PortfolioColors.surface,
        ),
        child: Padding(
          padding: EdgeInsets.all(context.isMobile ? 24 : 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Continue',
                style: PortfolioTypography.headlineSmall(context),
              ),
              const SizedBox(height: 12),
              Text(
                'Explore another project or start a conversation about similar work.',
                style: PortfolioTypography.body(),
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  if (nextProject != null)
                    FilledButton(
                      style: PortfolioButtons.primary(),
                      onPressed: () =>
                          context.go(AppRoutes.caseStudy(nextProject!.id)),
                      child: Text('Next: ${nextProject!.name}'),
                    ),
                  OutlinedButton(
                    style: PortfolioButtons.secondary(),
                    onPressed: onDiscuss,
                    child: const Text('Discuss a similar project'),
                  ),
                  TextButton(
                    style: PortfolioButtons.text(),
                    onPressed: onBackToWork,
                    child: const Text('All projects'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
