import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/portfolio_colors.dart';
import '../../../../core/constants/portfolio_constants.dart';
import '../../../../core/routing/home_scroll_memory.dart';
import '../../../../core/routing/section_routes.dart';
import '../../../../core/utils/animations.dart';
import '../../../../core/utils/section_scroll.dart';
import '../../../../presentation/widgets/portfolio_nav_bar.dart';
import '../../../portfolio/presentation/cubit/portfolio_cubit.dart';
import '../../../portfolio/presentation/cubit/portfolio_state.dart';
import '../../../portfolio/presentation/cubit/profile_cubit.dart';
import '../../../portfolio/presentation/cubit/profile_state.dart';
import '../cubit/shell_cubit.dart';
import '../cubit/shell_state.dart';
import '../sections/about_section.dart';
import '../sections/codewend_section.dart';
import '../sections/contact_section.dart';
import '../sections/experience_section.dart';
import '../sections/hero_section.dart';
import '../sections/work_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.initialSection = ShellSection.hero});

  final ShellSection initialSection;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _heroKey = GlobalKey();
  final _codewendKey = GlobalKey();
  final _workKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _contactKey = GlobalKey();
  final _workFocusNode = FocusNode(debugLabel: 'work-heading');

  bool _programmaticScroll = false;
  int _scrollGeneration = 0;
  ShellSection? _pendingSection;
  bool _restoredMemory = false;
  bool _activeSectionUpdateScheduled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrapScroll());
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSection != widget.initialSection) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _scrollToSection(widget.initialSection);
      });
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _workFocusNode.dispose();
    super.dispose();
  }

  void _bootstrapScroll() {
    if (!mounted) return;

    final saved = HomeScrollMemory.offset;
    if (saved != null && _scrollController.hasClients) {
      final max = _scrollController.position.maxScrollExtent;
      _scrollController.jumpTo(saved.clamp(0.0, max));
      final remembered = HomeScrollMemory.section;
      HomeScrollMemory.clear();
      _restoredMemory = true;
      if (remembered != null) {
        context.read<ShellCubit>().setActiveSection(remembered);
      }
      _syncScrolledFromOffset();
      _updateActiveSection();
      return;
    }

    if (widget.initialSection != ShellSection.hero) {
      _scrollToSection(widget.initialSection);
    } else {
      _syncScrolledFromOffset();
      _updateActiveSection();
    }
  }

  void _syncScrolledFromOffset() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;
    final scrolled = context.read<ShellCubit>().state.scrolled;
    if (!scrolled && offset > PortfolioConstants.scrollEnterThreshold) {
      context.read<ShellCubit>().setScrolled(true);
    } else if (scrolled && offset < PortfolioConstants.scrollExitThreshold) {
      context.read<ShellCubit>().setScrolled(false);
    } else if (!scrolled && offset <= PortfolioConstants.scrollExitThreshold) {
      context.read<ShellCubit>().setScrolled(false);
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;
    final scrolled = context.read<ShellCubit>().state.scrolled;

    if (!scrolled && offset > PortfolioConstants.scrollEnterThreshold) {
      context.read<ShellCubit>().setScrolled(true);
    } else if (scrolled && offset < PortfolioConstants.scrollExitThreshold) {
      context.read<ShellCubit>().setScrolled(false);
    }

    if (!_programmaticScroll) {
      _scheduleActiveSectionUpdate();
    }
  }

  void _scheduleActiveSectionUpdate() {
    if (_activeSectionUpdateScheduled) return;
    _activeSectionUpdateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _activeSectionUpdateScheduled = false;
      if (!mounted || _programmaticScroll) return;
      _updateActiveSection();
    });
  }

  /// Active section = last section whose heading crossed the scrolled-nav line.
  /// Contact is special: the page often cannot scroll far enough for its
  /// heading to reach that line, so the bottom of the scroll range counts.
  void _updateActiveSection() {
    if (_scrollController.hasClients) {
      final position = _scrollController.position;
      if (position.maxScrollExtent > 0 &&
          position.pixels >= position.maxScrollExtent - 24) {
        context.read<ShellCubit>().setActiveSection(ShellSection.contact);
        return;
      }
    }

    final entries = <ShellSection, GlobalKey>{
      ShellSection.hero: _heroKey,
      ShellSection.work: _workKey,
      ShellSection.about: _aboutKey,
      ShellSection.contact: _contactKey,
    };

    final threshold = SectionScroll.activeSectionThreshold(context);
    ShellSection active = ShellSection.hero;

    for (final entry in entries.entries) {
      final box = entry.value.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final dy = box.localToGlobal(Offset.zero).dy;
      if (dy <= threshold) {
        active = entry.key;
      }
    }

    final contactBox =
        _contactKey.currentContext?.findRenderObject() as RenderBox?;
    if (contactBox != null && contactBox.hasSize) {
      final contactTop = contactBox.localToGlobal(Offset.zero).dy;
      final viewportHeight = MediaQuery.sizeOf(context).height;
      if (contactTop < viewportHeight && active == ShellSection.about) {
        final aboutBox =
            _aboutKey.currentContext?.findRenderObject() as RenderBox?;
        final aboutTop = aboutBox?.localToGlobal(Offset.zero).dy ?? 0;
        if (contactTop <= aboutTop || contactTop < viewportHeight * 0.55) {
          active = ShellSection.contact;
        }
      }
    }

    context.read<ShellCubit>().setActiveSection(active);
  }

  GlobalKey _keyFor(ShellSection section) => switch (section) {
    ShellSection.hero => _heroKey,
    ShellSection.work => _workKey,
    ShellSection.about => _aboutKey,
    ShellSection.contact => _contactKey,
  };

  Future<void> _scrollToSection(
    ShellSection section, {
    bool focusWork = false,
  }) async {
    final generation = ++_scrollGeneration;
    context.read<ShellCubit>().setActiveSection(section);
    _pendingSection = section;

    final scrollDuration = PortfolioMotion.of(
      context,
      PortfolioMotion.sectionScroll,
    );
    const scrollCurve = motionEase;

    if (section == ShellSection.hero) {
      _programmaticScroll = true;
      await SectionScroll.animateToTop(
        context: context,
        controller: _scrollController,
        duration: scrollDuration,
        curve: scrollCurve,
      );
      if (!mounted || generation != _scrollGeneration) return;
      context.read<ShellCubit>().setScrolled(false);
      _programmaticScroll = false;
      _pendingSection = null;
      _updateActiveSection();
      return;
    }

    final key = _keyFor(section);
    final targetContext = key.currentContext;
    if (targetContext == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || generation != _scrollGeneration) return;
        _scrollToSection(section, focusWork: focusWork);
      });
      return;
    }

    _programmaticScroll = true;
    await SectionScroll.animateToAnchor(
      context: context,
      controller: _scrollController,
      anchorKey: key,
      duration: scrollDuration,
      curve: scrollCurve,
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
    _syncScrolledFromOffset();
    _programmaticScroll = false;
    _pendingSection = null;
    _updateActiveSection();

    if (focusWork && section == ShellSection.work) {
      _workFocusNode.requestFocus();
    }
  }

  void _onNavigate(ShellSection section) {
    final path = SectionRoutes.pathFor(section);
    final current = GoRouterState.of(context).uri.path;
    final currentSection = SectionRoutes.sectionFromPath(current);

    if (section == ShellSection.hero) {
      if (currentSection == ShellSection.hero) {
        _scrollToSection(ShellSection.hero);
        return;
      }

      context.go(path);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _scrollToSection(ShellSection.hero);
      });
      return;
    }

    if (currentSection == section) {
      _scrollToSection(section);
      return;
    }
    context.go(path);
  }

  void _skipToContent() {
    final path = SectionRoutes.pathFor(ShellSection.work);
    final current = GoRouterState.of(context).uri.path;
    if (SectionRoutes.sectionFromPath(current) != ShellSection.work) {
      context.go(path);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollToSection(ShellSection.work, focusWork: true);
    });
  }

  void _rememberScroll() {
    if (!_scrollController.hasClients) return;
    HomeScrollMemory.save(
      offset: _scrollController.offset,
      section: context.read<ShellCubit>().state.activeSection,
    );
  }

  void _onContentReady() {
    if (_restoredMemory) return;
    final pending =
        _pendingSection ??
        (widget.initialSection != ShellSection.hero
            ? widget.initialSection
            : null);
    if (pending == null || pending == ShellSection.hero) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollToSection(pending);
    });
  }

  @override
  Widget build(BuildContext context) {
    final safeTop = PortfolioConstants.safeAreaTop(
      MediaQuery.paddingOf(context).top,
    );
    final navInset = PortfolioConstants.navOccupiedAtTop(safeTop);

    return Scaffold(
      backgroundColor: PortfolioColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: PrimaryScrollController(
              controller: _scrollController,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: BlocBuilder<PortfolioCubit, PortfolioState>(
                      builder: (context, state) {
                        final featured =
                            state is PortfolioReady && state.projects.isNotEmpty
                            ? state.projects.first
                            : null;
                        return HeroSection(
                          topInset: navInset,
                          headingKey: _heroKey,
                          featuredProject: featured,
                          onExploreWork: () => _onNavigate(ShellSection.work),
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: KeyedSubtree(
                      key: _codewendKey,
                      child: const CodewendSection(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: BlocConsumer<PortfolioCubit, PortfolioState>(
                      listener: (context, state) {
                        if (state is PortfolioReady) _onContentReady();
                      },
                      builder: (context, state) {
                        if (state is PortfolioReady) {
                          return WorkSection(
                            headingKey: _workKey,
                            headingFocusNode: _workFocusNode,
                            projects: state.projects,
                            onOpenProject: _rememberScroll,
                          );
                        }
                        if (state is PortfolioFailure) {
                          return Padding(
                            padding: const EdgeInsets.all(48),
                            child: Text(state.message),
                          );
                        }
                        return const SizedBox(height: 240);
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: BlocConsumer<ProfileCubit, ProfileState>(
                      listener: (context, state) {
                        if (state is ProfileReady) _onContentReady();
                      },
                      builder: (context, state) {
                        if (state is ProfileReady) {
                          return AboutSection(
                            headingKey: _aboutKey,
                            profile: state.profile,
                          );
                        }
                        return const SizedBox(height: 240);
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        if (state is ProfileReady) {
                          return ExperienceSection(
                            headingKey: _experienceKey,
                            profile: state.profile,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        if (state is ProfileReady) {
                          return ContactSection(
                            headingKey: _contactKey,
                            profile: state.profile,
                          );
                        }
                        return const SizedBox(height: 200);
                      },
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
            child: PortfolioNavBar(
              onNavigate: _onNavigate,
              onSkipToContent: _skipToContent,
            ),
          ),
        ],
      ),
    );
  }
}
