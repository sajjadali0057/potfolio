import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/portfolio_buttons.dart';
import '../../../../app/theme/portfolio_colors.dart';
import '../../../../app/theme/portfolio_typography.dart';
import '../../../../core/constants/portfolio_constants.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/utils/preview_assets.dart';
import '../../../../presentation/widgets/portfolio_image.dart';
import '../../../../presentation/widgets/section_band.dart';
import '../../../portfolio/domain/entities/project.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.onExploreWork,
    this.featuredProject,
    this.headingKey,
    this.topInset = 0,
  });

  final VoidCallback onExploreWork;
  final Project? featuredProject;
  final Key? headingKey;
  /// Space reserved under the overlay navbar (owned by this module).
  final double topInset;

  Future<void> _openResume(BuildContext context) async {
    final uri = Uri.base.resolve(PortfolioConstants.resumeUrl);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the resume.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            key: headingKey,
            'Engineering reliable digital products.',
            style: PortfolioTypography.display(context).copyWith(
              fontSize: context.isMobile
                  ? 36
                  : context.isTablet
                  ? 48
                  : 60,
              height: 1.08,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Senior Full Stack Software Engineer & Founder of CodeWend',
          style: PortfolioTypography.titleMedium(),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Text(
            'I help businesses deliver reliable mobile and web applications through thoughtful architecture, scalable backend services and automated release workflows.',
            style: PortfolioTypography.bodyLarge(),
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FilledButton(
              onPressed: onExploreWork,
              style: PortfolioButtons.primary(),
              child: const Text('Explore projects'),
            ),
            TextButton(
              style: PortfolioButtons.text(),
              onPressed: () => _openResume(context),
              child: const Text('View resume'),
            ),
          ],
        ),
      ],
    );

    const facts = <(String, String)>[
      ('5+ years', 'Building cross-platform products'),
      ('Mobile to backend', 'Flutter · Spring Boot · PostgreSQL'),
      ('Built to ship', 'GitHub Actions · Azure DevOps · Store releases'),
    ];

    return SectionBand(
      color: PortfolioColors.sectionBandA,
      child: Column(
        children: [
          if (topInset > 0) SizedBox(height: topInset),
          PortfolioContainer(
            child: Padding(
              padding: EdgeInsets.only(
                top: isDesktop ? 56 : 32,
                bottom: isDesktop ? 48 : 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!isDesktop) ...[
                    intro,
                    const SizedBox(height: 32),
                    const IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 4,
                            child: _FactsColumn(facts: facts),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 5,
                            child: _Portrait(),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    _MatchedHeightRow(
                      left: intro,
                      right: const _Portrait(fillHeight: true),
                    ),
                    const SizedBox(height: 40),
                    const Divider(color: PortfolioColors.divider),
                    const SizedBox(height: 20),
                    const _FactsWrap(facts: facts),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FactsColumn extends StatelessWidget {
  const _FactsColumn({required this.facts});

  final List<(String, String)> facts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final fact in facts) _Fact(value: fact.$1, label: fact.$2),
      ],
    );
  }
}

class _FactsWrap extends StatelessWidget {
  const _FactsWrap({required this.facts});

  final List<(String, String)> facts;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.isMobile ? 28 : 72,
      runSpacing: 20,
      children: [
        for (final fact in facts) _Fact(value: fact.$1, label: fact.$2),
      ],
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: context.isMobile ? double.infinity : 280,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: PortfolioTypography.titleMedium()),
        const SizedBox(height: 6),
        Text(label, style: PortfolioTypography.bodySmall()),
      ],
    ),
  );
}

/// Sizes [right] (photo + caption) to the measured height of [left].
class _MatchedHeightRow extends StatefulWidget {
  const _MatchedHeightRow({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  State<_MatchedHeightRow> createState() => _MatchedHeightRowState();
}

class _MatchedHeightRowState extends State<_MatchedHeightRow> {
  final _leftKey = GlobalKey();
  double? _height;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  void didUpdateWidget(covariant _MatchedHeightRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    final box = _leftKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final next = box.size.height;
    if (_height == next) return;
    setState(() => _height = next);
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.sizeOf(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: KeyedSubtree(key: _leftKey, child: widget.left),
        ),
        const SizedBox(width: 56),
        Expanded(
          flex: 3,
          child: _height == null
              ? widget.right
              : SizedBox(height: _height, child: widget.right),
        ),
      ],
    );
  }
}

class _Portrait extends StatelessWidget {
  const _Portrait({this.fillHeight = false});

  final bool fillHeight;

  @override
  Widget build(BuildContext context) {
    if (fillHeight) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final maxW = constraints.maxWidth;
          final maxH = constraints.maxHeight;

          // When height is bounded (matched row), fill the available box.
          if (maxH.isFinite && maxH > 0) {
            return SizedBox(
              width: maxW,
              height: maxH,
              child: _photo(),
            );
          }

          var width = maxW;
          var height = width * 5 / 4;
          return Align(
            alignment: Alignment.topRight,
            child: SizedBox(width: width, height: height, child: _photo()),
          );
        },
      );
    }

    return AspectRatio(aspectRatio: 4 / 5, child: _photo());
  }

  Widget _photo() => ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: ColoredBox(
      color: PortfolioColors.surface,
      child: SizedBox.expand(
        child: PortfolioImage(
          PreviewAssets.resolve('images/profile/sajjad-ali.png'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          semanticLabel: 'Sajjad Ali, Founder of CodeWend',
          cacheWidth: 900,
        ),
      ),
    ),
  );
}
