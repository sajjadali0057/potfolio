import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/portfolio_colors.dart';
import '../../app/theme/portfolio_typography.dart';
import '../../core/constants/portfolio_constants.dart';
import '../../core/utils/animations.dart';
import 'portfolio_image.dart';

/// Horizontal pager that shows exactly one project image at a time.
class ProjectImageCarousel extends StatefulWidget {
  const ProjectImageCarousel({
    super.key,
    required this.images,
    required this.semanticLabelPrefix,
    this.captions = const [],
    this.fit = BoxFit.contain,
    this.backgroundColor,
    this.showControls = true,
    this.cacheWidth,
  });

  final List<String> images;
  final List<String> captions;
  final String semanticLabelPrefix;
  final BoxFit fit;
  final Color? backgroundColor;
  final bool showControls;
  final int? cacheWidth;

  @override
  State<ProjectImageCarousel> createState() => _ProjectImageCarouselState();
}

class _ProjectImageCarouselState extends State<ProjectImageCarousel> {
  late final PageController _controller;
  late final FocusNode _regionFocusNode;
  int _index = 0;
  int _navGeneration = 0;

  static const double _arrowSlot = PortfolioConstants.minTapTarget;
  static const double _dotSlot = PortfolioConstants.minTapTarget;
  static const double _dotGap = 4;
  static const double _sidePadding = 16;
  static const double _counterReserve = 72;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _regionFocusNode = FocusNode(debugLabel: 'project-carousel');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (prefersReducedMotion(context) && _controller.hasClients) {
      final page = _controller.page?.round() ?? _index;
      if ((_controller.page ?? page.toDouble()) != page.toDouble()) {
        _controller.jumpToPage(page);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _regionFocusNode.dispose();
    super.dispose();
  }

  String _labelFor(int index) {
    if (index >= 0 &&
        index < widget.captions.length &&
        widget.captions[index].trim().isNotEmpty) {
      return widget.captions[index];
    }
    return '${widget.semanticLabelPrefix} ${index + 1} of ${widget.images.length}';
  }

  bool _dotsFit(double width, int count) {
    if (count <= 1) return true;
    final dotsWidth = count * _dotSlot + (count - 1) * _dotGap;
    final needed = _sidePadding + (_arrowSlot * 2) + dotsWidth + 8;
    return needed <= width;
  }

  Future<void> _goTo(int index) async {
    if (index < 0 || index >= widget.images.length || index == _index) return;
    final generation = ++_navGeneration;
    final duration = PortfolioMotion.of(context, PortfolioMotion.carousel);

    if (duration == Duration.zero) {
      _controller.jumpToPage(index);
      if (mounted && generation == _navGeneration) {
        setState(() => _index = index);
      }
      return;
    }

    await _controller.animateToPage(
      index,
      duration: duration,
      curve: motionEase,
    );

    if (!mounted || generation != _navGeneration) return;
    if (prefersReducedMotion(context)) {
      _controller.jumpToPage(index);
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _goTo(_index - 1);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _goTo(_index + 1);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.home) {
      _goTo(0);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.end) {
      _goTo(widget.images.length - 1);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images;
    if (images.isEmpty) {
      return const _FailureState();
    }

    if (images.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _Slide(
              asset: images.first,
              fit: widget.fit,
              label: _labelFor(0),
              backgroundColor: widget.backgroundColor,
              cacheWidth: widget.cacheWidth,
            ),
          ),
          if (widget.captions.isNotEmpty &&
              widget.captions.first.trim().isNotEmpty)
            _Caption(text: widget.captions.first),
        ],
      );
    }

    final caption = _labelFor(_index);

    return Focus(
      focusNode: _regionFocusNode,
      onKeyEvent: _onKey,
      child: Semantics(
        container: true,
        liveRegion: true,
        label:
            '${widget.semanticLabelPrefix}, image ${_index + 1} of ${images.length}. ${_labelFor(_index)}',
        excludeSemantics: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final useDots = _dotsFit(constraints.maxWidth, images.length);

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        controller: _controller,
                        itemCount: images.length,
                        allowImplicitScrolling: false,
                        onPageChanged: (value) {
                          if (!mounted) return;
                          setState(() => _index = value);
                          // Do not steal focus from pointer/touch or other controls.
                        },
                        itemBuilder: (context, index) => ExcludeSemantics(
                          child: _Slide(
                            asset: images[index],
                            fit: widget.fit,
                            label: _labelFor(index),
                            backgroundColor: widget.backgroundColor,
                            cacheWidth: widget.cacheWidth,
                          ),
                        ),
                      ),
                      if (widget.showControls)
                        Positioned(
                          left: 8,
                          right: 8,
                          bottom: 10,
                          child: Row(
                            children: [
                              _NavButton(
                                icon: Icons.chevron_left_rounded,
                                enabled: _index > 0,
                                onPressed: () => _goTo(_index - 1),
                                tooltip: 'Previous image',
                              ),
                              Expanded(
                                child: Center(
                                  child: useDots
                                      ? _Dots(
                                          count: images.length,
                                          index: _index,
                                          onSelect: _goTo,
                                          labelPrefix:
                                              widget.semanticLabelPrefix,
                                        )
                                      : ExcludeSemantics(
                                          child: _Counter(
                                            index: _index,
                                            count: images.length,
                                          ),
                                        ),
                                ),
                              ),
                              _NavButton(
                                icon: Icons.chevron_right_rounded,
                                enabled: _index < images.length - 1,
                                onPressed: () => _goTo(_index + 1),
                                tooltip: 'Next image',
                              ),
                            ],
                          ),
                        ),
                      if (widget.showControls && useDots)
                        const Positioned(
                          top: 10,
                          right: 12,
                          child: SizedBox(width: _counterReserve),
                        ),
                      if (widget.showControls && useDots)
                        Positioned(
                          top: 10,
                          right: 12,
                          child: ExcludeSemantics(
                            child: _Counter(
                              index: _index,
                              count: images.length,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            if (widget.captions.isNotEmpty)
              ExcludeSemantics(child: _Caption(text: caption))
            else
              const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }
}

class _Caption extends StatelessWidget {
  const _Caption({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 10, 4, 0),
      child: Text(
        text,
        style: PortfolioTypography.meta(),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({required this.index, required this.count});

  final int index;
  final int count;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: PortfolioColors.controlScrim,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          '${index + 1} / $count',
          style: PortfolioTypography.meta().copyWith(
            color: PortfolioColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _FailureState extends StatelessWidget {
  const _FailureState();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: PortfolioColors.surface,
      child: Center(
        child: Text(
          'Preview unavailable',
          style: PortfolioTypography.meta(),
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({
    required this.asset,
    required this.fit,
    required this.label,
    this.backgroundColor,
    this.cacheWidth,
  });

  final String asset;
  final BoxFit fit;
  final String label;
  final Color? backgroundColor;
  final int? cacheWidth;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor ?? Colors.transparent,
      child: PortfolioImage(
        asset,
        fit: fit,
        semanticLabel: label,
        cacheWidth: cacheWidth,
        errorBuilder: (_, error, stack) => const _FailureState(),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({
    required this.count,
    required this.index,
    required this.onSelect,
    required this.labelPrefix,
  });

  final int count;
  final int index;
  final ValueChanged<int> onSelect;
  final String labelPrefix;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: _ProjectImageCarouselState._dotGap),
          Semantics(
            button: true,
            selected: i == index,
            label: '$labelPrefix ${i + 1} of $count',
            excludeSemantics: true,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSelect(i),
                customBorder: const CircleBorder(),
                child: SizedBox(
                  width: PortfolioConstants.minTapTarget,
                  height: PortfolioConstants.minTapTarget,
                  child: Center(
                    child: AnimatedContainer(
                      duration:
                          PortfolioMotion.of(context, PortfolioMotion.micro),
                      curve: motionEase,
                      width: i == index ? 18 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == index
                            ? PortfolioColors.accent
                            : PortfolioColors.textMuted.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(
                          color: PortfolioColors.controlScrim.withValues(
                            alpha: 0.35,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      excludeFromSemantics: true,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: tooltip,
        excludeSemantics: true,
        child: Material(
          color: PortfolioColors.controlScrim.withValues(
            alpha: enabled ? 0.85 : 0.4,
          ),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: enabled ? onPressed : null,
            child: SizedBox(
              width: PortfolioConstants.minTapTarget,
              height: PortfolioConstants.minTapTarget,
              child: Icon(
                icon,
                size: 24,
                color: enabled
                    ? PortfolioColors.textPrimary
                    : PortfolioColors.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
