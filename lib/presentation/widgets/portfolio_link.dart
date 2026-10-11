import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/link.dart';

import '../../app/theme/portfolio_buttons.dart';
import '../../app/theme/portfolio_colors.dart';
import '../../app/theme/portfolio_typography.dart';
import '../../core/utils/animations.dart';

class PortfolioLink extends StatefulWidget {
  const PortfolioLink({
    super.key,
    required this.label,
    required this.onPressed,
    this.active = false,
    this.style,
    this.href,
  });

  final String label;
  final VoidCallback onPressed;
  final bool active;
  final TextStyle? style;

  /// Browser-visible destination. When set, the control is a real link on web
  /// (open-in-new-tab / copy-link) while ordinary activation stays in-app.
  final String? href;

  @override
  State<PortfolioLink> createState() => _PortfolioLinkState();
}

class _PortfolioLinkState extends State<PortfolioLink> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final href = widget.href;
    if (href != null && href.isNotEmpty) {
      return Link(
        uri: Uri.parse(href),
        target: LinkTarget.self,
        builder: (context, followLink) => _linkBody(isLink: true),
      );
    }
    return _linkBody(isLink: false);
  }

  Widget _linkBody({required bool isLink}) {
    final base = widget.style ?? PortfolioTypography.nav();
    final emphasized = widget.active || _hovered || _focused;
    final color =
        emphasized ? PortfolioColors.accent : PortfolioColors.textSecondary;

    return Semantics(
      link: isLink,
      button: !isLink,
      selected: widget.active,
      label: widget.label,
      excludeSemantics: true,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: (value) => setState(() => _hovered = value),
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onPressed();
              return null;
            },
          ),
        },
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        child: GestureDetector(
          onTap: widget.onPressed,
          behavior: HitTestBehavior.opaque,
          child: AnimatedDefaultTextStyle(
            duration: PortfolioMotion.of(context, PortfolioMotion.micro),
            curve: motionEase,
            style: base.copyWith(color: color),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(widget.label),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 2,
                  child: AnimatedContainer(
                    duration: PortfolioMotion.of(context, PortfolioMotion.micro),
                    curve: motionEase,
                    height: 1,
                    color: emphasized
                        ? PortfolioColors.accent
                        : Colors.transparent,
                  ),
                ),
                if (_focused)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: PortfolioColors.focusRing),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PortfolioTextButton extends StatefulWidget {
  const PortfolioTextButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  State<PortfolioTextButton> createState() => _PortfolioTextButtonState();
}

class _PortfolioTextButtonState extends State<PortfolioTextButton> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final active = _hovered || _focused || _pressed;
    return Semantics(
      button: true,
      label: widget.label,
      excludeSemantics: true,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: (value) => setState(() => _hovered = value),
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onPressed();
              return null;
            },
          ),
        },
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: PortfolioMotion.of(context, PortfolioMotion.micro),
            curve: motionEase,
            constraints:
                const BoxConstraints(minHeight: PortfolioButtons.height),
            padding: PortfolioButtons.padding,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? PortfolioColors.accent : Colors.transparent,
              border: Border.all(
                color: active ? PortfolioColors.accent : PortfolioColors.divider,
              ),
              borderRadius: BorderRadius.circular(PortfolioButtons.radius),
            ),
            child: Text(
              widget.label,
              style: PortfolioTypography.button().copyWith(
                color: PortfolioColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
