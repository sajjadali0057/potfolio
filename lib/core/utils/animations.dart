import 'dart:async';

import 'package:flutter/material.dart';

/// Returns true when the user prefers reduced motion.
bool prefersReducedMotion(BuildContext context) {
  return MediaQuery.disableAnimationsOf(context) ||
      MediaQuery.maybeOf(context)?.disableAnimations == true;
}

/// Horizontal slide direction for reveal animations.
enum RevealFrom { left, right, up }

/// Motion ease used for entrances: fast start, soft settle.
const Curve motionEase = Cubic(0.16, 1, 0.3, 1);

/// Shared motion durations for portfolio interactions.
abstract final class PortfolioMotion {
  static const Duration micro = Duration(milliseconds: 150);
  static const Duration carousel = Duration(milliseconds: 250);
  static const Duration page = Duration(milliseconds: 180);
  static const Duration nav = Duration(milliseconds: 200);
  static const Duration sectionScroll = Duration(milliseconds: 320);
  static const Duration hover = Duration(milliseconds: 180);

  static Duration of(BuildContext context, Duration normal) {
    return prefersReducedMotion(context) ? Duration.zero : normal;
  }
}

Offset _revealOffset(RevealFrom from, {double distance = 12}) {
  return switch (from) {
    RevealFrom.left => Offset(-distance, 8),
    RevealFrom.right => Offset(distance, 8),
    RevealFrom.up => const Offset(0, 12),
  };
}

/// Shared scroll listener — throttled so visibility checks don't run every pixel.
class _ScrollRevealBus {
  _ScrollRevealBus._();

  static final Set<VoidCallback> _listeners = <VoidCallback>{};
  static ScrollController? _controller;
  static bool _scheduled = false;
  static double _lastCheckedOffset = double.nan;

  static void register(ScrollController controller, VoidCallback listener) {
    _listeners.add(listener);
    if (!identical(_controller, controller)) {
      _controller?.removeListener(_onScroll);
      _controller = controller;
      _controller!.addListener(_onScroll);
      _lastCheckedOffset = double.nan;
    }
  }

  static void unregister(VoidCallback listener) {
    _listeners.remove(listener);
    if (_listeners.isEmpty) {
      _controller?.removeListener(_onScroll);
      _controller = null;
      _lastCheckedOffset = double.nan;
    }
  }

  static void _onScroll() {
    if (_scheduled || _controller == null) return;
    final offset = _controller!.offset;
    if (!_lastCheckedOffset.isNaN && (offset - _lastCheckedOffset).abs() < 24) {
      return;
    }
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      _lastCheckedOffset = _controller?.offset ?? offset;
      for (final listener in List<VoidCallback>.of(_listeners)) {
        listener();
      }
    });
  }
}

/// Lightweight fade/slide reveal that starts after the first frame.
class AnimatedReveal extends StatefulWidget {
  const AnimatedReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = PortfolioMotion.page,
    this.from = RevealFrom.up,
    this.offset,
    this.fade = true,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final RevealFrom from;
  final Offset? offset;
  final bool fade;

  @override
  State<AnimatedReveal> createState() => _AnimatedRevealState();
}

class _AnimatedRevealState extends State<AnimatedReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  bool _started = false;
  bool _completed = false;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    final curve = CurvedAnimation(parent: _controller, curve: motionEase);
    _opacity = Tween<double>(begin: widget.fade ? 0 : 1, end: 1).animate(curve);
    _slide = Tween<Offset>(
      begin: widget.offset ?? _revealOffset(widget.from),
      end: Offset.zero,
    ).animate(curve);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _completed = true);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStart());
  }

  void _finishImmediately() {
    _delayTimer?.cancel();
    _controller.value = 1;
    _started = true;
    _completed = true;
  }

  void _maybeStart() {
    if (!mounted || _started || _completed) return;
    if (prefersReducedMotion(context)) {
      _finishImmediately();
      setState(() {});
      return;
    }
    _started = true;
    if (widget.delay == Duration.zero) {
      _controller.forward();
      return;
    }
    _delayTimer = Timer(widget.delay, () {
      if (!mounted) return;
      if (prefersReducedMotion(context)) {
        _finishImmediately();
        setState(() {});
        return;
      }
      _controller.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (prefersReducedMotion(context) && !_completed) {
      _finishImmediately();
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (prefersReducedMotion(context) || _completed) {
      return widget.child;
    }

    return ExcludeFocus(
      excluding: _opacity.value < 0.05,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacity.value.clamp(0.0, 1.0),
              child: Transform.translate(offset: _slide.value, child: child),
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}

/// Reveals content when it enters the viewport (listens to the primary scroll).
class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = PortfolioMotion.page,
    this.from = RevealFrom.up,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final RevealFrom from;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  bool _revealed = false;
  bool _completed = false;
  Timer? _delayTimer;
  ScrollController? _scrollController;
  late final VoidCallback _busListener;

  @override
  void initState() {
    super.initState();
    _busListener = _checkVisibility;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    final curve = CurvedAnimation(parent: _controller, curve: motionEase);
    _opacity = Tween<double>(begin: 0, end: 1).animate(curve);
    _slide = Tween<Offset>(
      begin: _revealOffset(widget.from),
      end: Offset.zero,
    ).animate(curve);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _completed = true);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _attachScrollListener();
      _checkVisibility();
    });
  }

  void _attachScrollListener() {
    if (!mounted || _revealed) return;
    final controller = PrimaryScrollController.maybeOf(context);
    if (controller == null) return;
    if (!identical(controller, _scrollController)) {
      if (_scrollController != null) {
        _ScrollRevealBus.unregister(_busListener);
      }
      _scrollController = controller;
      _ScrollRevealBus.register(controller, _busListener);
    }
  }

  void _detachScrollListener() {
    if (_scrollController != null) {
      _ScrollRevealBus.unregister(_busListener);
      _scrollController = null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (prefersReducedMotion(context) && !_completed) {
      _reveal(immediate: true);
    }
  }

  @override
  void dispose() {
    _detachScrollListener();
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _reveal({bool immediate = false}) {
    if (!mounted) return;
    if (_completed) return;

    if (immediate || prefersReducedMotion(context)) {
      _delayTimer?.cancel();
      _revealed = true;
      _completed = true;
      _detachScrollListener();
      _controller.value = 1;
      setState(() {});
      return;
    }

    if (_revealed) return;
    _revealed = true;
    _detachScrollListener();

    if (widget.delay == Duration.zero) {
      _controller.forward();
      return;
    }
    _delayTimer = Timer(widget.delay, () {
      if (!mounted) return;
      if (prefersReducedMotion(context)) {
        _reveal(immediate: true);
        return;
      }
      _controller.forward();
    });
  }

  void _checkVisibility() {
    if (_revealed || !mounted) return;
    if (prefersReducedMotion(context)) {
      _reveal(immediate: true);
      return;
    }
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final position = box.localToGlobal(Offset.zero);
    final size = box.size;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final visible =
        position.dy < screenHeight * 0.92 && position.dy + size.height > 0;

    if (!visible) return;
    _reveal();
  }

  @override
  Widget build(BuildContext context) {
    if (!_revealed) {
      _attachScrollListener();
    }

    if (prefersReducedMotion(context) || _completed) {
      return widget.child;
    }

    final hiding = !_revealed || _opacity.value < 0.05;

    return Focus(
      canRequestFocus: false,
      onFocusChange: (hasFocus) {
        if (hasFocus) _reveal(immediate: true);
      },
      child: ExcludeFocus(
        excluding: hiding,
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _opacity.value.clamp(0.0, 1.0),
                child: Transform.translate(offset: _slide.value, child: child),
              );
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// Subtle scale on hover / focus for project imagery.
class HoverScale extends StatefulWidget {
  const HoverScale({
    super.key,
    required this.child,
    this.scale = 1.015,
    this.enabled = true,
  });

  final Widget child;
  final double scale;
  final bool enabled;

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final reduce = prefersReducedMotion(context);
    final active = _hovered || _focused;

    return FocusableActionDetector(
      onShowHoverHighlight: (value) {
        if (!widget.enabled) return;
        setState(() => _hovered = value);
      },
      onShowFocusHighlight: (value) {
        if (!widget.enabled) return;
        setState(() => _focused = value);
      },
      child: AnimatedScale(
        scale: !widget.enabled || reduce || !active ? 1 : widget.scale,
        duration: PortfolioMotion.of(context, PortfolioMotion.hover),
        curve: motionEase,
        child: widget.child,
      ),
    );
  }
}
