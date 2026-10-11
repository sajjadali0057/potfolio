import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajjad_ali_portfolio/core/constants/portfolio_constants.dart';
import 'package:sajjad_ali_portfolio/core/routing/home_scroll_memory.dart';
import 'package:sajjad_ali_portfolio/core/routing/section_routes.dart';
import 'package:sajjad_ali_portfolio/core/utils/animations.dart';
import 'package:sajjad_ali_portfolio/core/utils/preview_assets.dart';
import 'package:sajjad_ali_portfolio/core/utils/section_scroll.dart';
import 'package:sajjad_ali_portfolio/features/portfolio/data/data_sources/portfolio_local_data_source.dart';
import 'package:sajjad_ali_portfolio/features/portfolio/presentation/cubit/case_study_state.dart';
import 'package:sajjad_ali_portfolio/features/shell/presentation/cubit/shell_state.dart';
import 'package:sajjad_ali_portfolio/presentation/widgets/portfolio_link.dart';
import 'package:sajjad_ali_portfolio/presentation/widgets/project_image_carousel.dart';

void main() {
  test('section routes map work about contact and home', () {
    expect(SectionRoutes.pathFor(ShellSection.hero), '/');
    expect(SectionRoutes.pathFor(ShellSection.work), '/work');
    expect(SectionRoutes.pathFor(ShellSection.about), '/about');
    expect(SectionRoutes.pathFor(ShellSection.contact), '/contact');
    expect(SectionRoutes.sectionFromPath('/work'), ShellSection.work);
    expect(SectionRoutes.isHomeShellPath('/about'), isTrue);
    expect(SectionRoutes.isHomeShellPath('/work/asharq-business'), isFalse);
  });

  test('nav clearance includes scrolled gap and reading space', () {
    expect(
      PortfolioConstants.sectionScrollOffset,
      PortfolioConstants.navHeight +
          PortfolioConstants.navTopSpacing +
          PortfolioConstants.sectionScrollClearance,
    );
    expect(PortfolioConstants.sectionScrollClearance, inInclusiveRange(16, 24));
    expect(PortfolioConstants.navTopSpacing, inInclusiveRange(16, 24));
    expect(
      PortfolioConstants.scrollEnterThreshold,
      greaterThan(PortfolioConstants.scrollExitThreshold),
    );
    expect(
      PortfolioConstants.navOccupiedAtTop(0),
      PortfolioConstants.navHeight,
    );
    expect(
      PortfolioConstants.navOccupiedScrolled(0),
      PortfolioConstants.navHeight + PortfolioConstants.navTopSpacing,
    );
    expect(
      PortfolioConstants.sectionScrollClearanceTotal(12),
      PortfolioConstants.navOccupiedScrolled(12) +
          PortfolioConstants.sectionScrollClearance,
    );
  });

  test('empty case-study sections are omitted from navigation', () {
    const source = PortfolioLocalDataSourceImpl();
    for (final project in source.projects()) {
      final visible = project.caseStudy.visibleSections();
      expect(visible, contains(CaseStudySection.overview));
      if (project.caseStudy.decisions.isEmpty &&
          project.caseStudy.learned.isEmpty) {
        expect(visible, isNot(contains(CaseStudySection.decisions)));
      }
      if (project.caseStudy.designAnnotations.isEmpty) {
        expect(visible, isNot(contains(CaseStudySection.screens)));
      }
    }
  });

  test('case study role and delivered copy are distinct', () {
    const source = PortfolioLocalDataSourceImpl();
    for (final project in source.projects()) {
      final study = project.caseStudy;
      expect(study.role.trim(), isNotEmpty);
      expect(study.outcomeSummary.trim(), isNotEmpty);
      expect(study.role.trim(), isNot(equals(study.outcomeSummary.trim())));
      expect(
        study.outcomeDetail.toLowerCase(),
        isNot(contains('technologies:')),
      );
      expect(CaseStudySection.outcome.label, 'Stack');
      expect(CaseStudySection.outcome.heading, 'Technologies');
    }
  });

  test('gallery annotations stay aligned with image assets', () {
    const source = PortfolioLocalDataSourceImpl();
    for (final project in source.projects()) {
      final annotations = project.caseStudy.designAnnotations;
      expect(annotations, isNotEmpty);
      expect(
        annotations.map((a) => a.imageAsset).toList(),
        project.imageAssets,
      );
      expect(project.coverAsset, project.imageAssets.first);
      expect(project.galleryAssets, project.imageAssets);
    }

    final asharq = source.projectById('asharq-business')!;
    expect(
      asharq.coverAsset,
      isNot(contains('063631')),
      reason: 'featured cover should be an application screen, not the logo',
    );
    expect(
      asharq.caseStudy.designAnnotations.last.caption.toLowerCase(),
      contains('brand'),
    );
    expect(
      asharq.caseStudy.designAnnotations.first.caption.toLowerCase(),
      isNot(contains('brand mark')),
    );

    final asharqNow = source.projectById('asharq-now')!;
    expect(asharqNow.coverAsset, isNot(contains('062857')));
    expect(
      asharqNow.caseStudy.designAnnotations.last.caption.toLowerCase(),
      contains('brand'),
    );
  });

  test('preview asset resolver maps screenshots into preview jpgs', () {
    expect(
      PreviewAssets.resolve(
        'images/portfolio/asharq-business/Screenshot_20260211_063631_LinkedIn.png',
      ),
      'images/portfolio/asharq-business/preview/Screenshot_20260211_063631_LinkedIn.jpg',
    );
    expect(
      PreviewAssets.resolve(
        'images/portfolio/chatcash/full-hd/1709196962326.jpg',
      ),
      'images/portfolio/chatcash/preview/1709196962326.jpg',
    );
  });

  test('home scroll memory round-trips portfolio position', () {
    HomeScrollMemory.clear();
    HomeScrollMemory.save(offset: 640, section: ShellSection.work);
    expect(HomeScrollMemory.offset, 640);
    expect(HomeScrollMemory.section, ShellSection.work);
    HomeScrollMemory.clear();
    expect(HomeScrollMemory.offset, isNull);
    expect(HomeScrollMemory.section, isNull);
  });

  testWidgets('studio link activates with keyboard', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PortfolioLink(
            label: 'About',
            href: '/about',
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(pressed, isTrue);

    final semantics = tester.getSemantics(find.text('About'));
    expect(semantics.label, 'About');
    expect(semantics.label.contains('About About'), isFalse);
  });

  testWidgets('reduced motion collapses studio motion durations', (
    tester,
  ) async {
    late BuildContext captured;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              captured = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    expect(prefersReducedMotion(captured), isTrue);
    expect(
      PortfolioMotion.of(captured, PortfolioMotion.sectionScroll),
      Duration.zero,
    );
    expect(
      PortfolioMotion.of(captured, PortfolioMotion.carousel),
      Duration.zero,
    );
    expect(PortfolioMotion.of(captured, PortfolioMotion.nav), Duration.zero);
  });

  testWidgets('scroll reveal completes immediately under reduced motion', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: Scaffold(
            body: ScrollReveal(
              delay: Duration(seconds: 2),
              child: Text('Revealed'),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Revealed'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('carousel uses compact counter when dots cannot fit', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 220,
            height: 360,
            child: ProjectImageCarousel(
              images: List<String>.generate(
                5,
                (i) => 'images/portfolio/irk/irk0${i + 1}.png',
              ),
              captions: List<String>.generate(5, (i) => 'Caption ${i + 1}'),
              semanticLabelPrefix: 'Demo',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('/'), findsWidgets);
    expect(find.byTooltip('Previous image'), findsOneWidget);
    expect(find.byTooltip('Next image'), findsOneWidget);
  });

  testWidgets('carousel keyboard navigation keeps initiating focus', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 480,
            height: 420,
            child: ProjectImageCarousel(
              images: [
                'images/portfolio/irk/irk01.png',
                'images/portfolio/irk/irk02.png',
                'images/portfolio/irk/irk03.png',
              ],
              captions: ['One', 'Two', 'Three'],
              semanticLabelPrefix: 'Demo',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final next = find.byTooltip('Next image');
    await tester.tap(next);
    await tester.pumpAndSettle();
    expect(find.text('Two'), findsOneWidget);

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(find.textContaining('Three'), findsWidgets);
  });

  testWidgets('section scroll destination clamps and clears header', (
    tester,
  ) async {
    final controller = ScrollController();
    final anchorKey = GlobalKey();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryScrollController(
            controller: controller,
            child: ListView(
              controller: controller,
              children: [
                const SizedBox(height: 400),
                SizedBox(
                  key: anchorKey,
                  height: 80,
                  child: const Text('Anchor heading'),
                ),
                const SizedBox(height: 1600),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final clearance = SectionScroll.headerClearance(
      tester.element(find.text('Anchor heading')),
    );
    expect(clearance, greaterThan(PortfolioConstants.navHeight));

    await SectionScroll.animateToAnchor(
      context: tester.element(find.text('Anchor heading')),
      controller: controller,
      anchorKey: anchorKey,
      duration: Duration.zero,
    );
    await tester.pumpAndSettle();

    final box = anchorKey.currentContext!.findRenderObject()! as RenderBox;
    final dy = box.localToGlobal(Offset.zero).dy;
    expect(dy, greaterThanOrEqualTo(clearance - 1));
    expect(dy, lessThanOrEqualTo(clearance + 2));

    await SectionScroll.animateToTop(
      context: tester.element(find.text('Anchor heading')),
      controller: controller,
      duration: Duration.zero,
    );
    await tester.pumpAndSettle();
    expect(controller.offset, 0);
  });

  testWidgets('rapid successive section scrolls honor the latest target', (
    tester,
  ) async {
    final controller = ScrollController();
    final firstKey = GlobalKey();
    final secondKey = GlobalKey();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            controller: controller,
            children: [
              SizedBox(key: firstKey, height: 120, child: const Text('First')),
              const SizedBox(height: 900),
              SizedBox(
                key: secondKey,
                height: 120,
                child: const Text('Second'),
              ),
              const SizedBox(height: 900),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.text('First'));
    // Fire two navigations; the second should win.
    final first = SectionScroll.animateToAnchor(
      context: context,
      controller: controller,
      anchorKey: firstKey,
      duration: const Duration(milliseconds: 200),
    );
    final second = SectionScroll.animateToAnchor(
      context: context,
      controller: controller,
      anchorKey: secondKey,
      duration: const Duration(milliseconds: 200),
    );
    await Future.wait([first, second]);
    await tester.pumpAndSettle();

    final expected = SectionScroll.destinationFor(
      controller: controller,
      anchorKey: secondKey,
      headerClearance: SectionScroll.headerClearance(context),
    );
    expect(controller.offset, closeTo(expected, 1));
  });

  test('page title brands Sajjad Ali portfolio', () {
    expect(
      PortfolioConstants.pageTitle.toLowerCase(),
      isNot(contains('signature')),
    );
    expect(PortfolioConstants.pageTitle, contains('Sajjad Ali'));
  });
}
