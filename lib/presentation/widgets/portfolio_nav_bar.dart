import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/link.dart';

import '../../app/theme/portfolio_colors.dart';
import '../../app/theme/portfolio_typography.dart';
import '../../core/constants/portfolio_constants.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/routing/section_routes.dart';
import '../../core/utils/animations.dart';
import '../../features/shell/presentation/cubit/shell_cubit.dart';
import '../../features/shell/presentation/cubit/shell_state.dart';
import 'portfolio_image.dart';
import 'portfolio_link.dart';

class PortfolioNavBar extends StatelessWidget {
  const PortfolioNavBar({
    super.key,
    required this.onNavigate,
    this.onSkipToContent,
  });

  final ValueChanged<ShellSection> onNavigate;
  final VoidCallback? onSkipToContent;

  @override
  Widget build(BuildContext context) {
    final safeTop = PortfolioConstants.safeAreaTop(
      MediaQuery.paddingOf(context).top,
    );

    return BlocBuilder<ShellCubit, ShellState>(
      buildWhen: (previous, current) =>
          previous.scrolled != current.scrolled ||
          previous.activeSection != current.activeSection,
      builder: (context, state) {
        final reduce = prefersReducedMotion(context);
        final gap = state.scrolled ? PortfolioConstants.navTopSpacing : 0.0;

        // Decorative gap lives only in this overlay (not document flow), so
        // page content never jumps. Animating height keeps hit-testing aligned
        // and avoids Stack clipping that Transform.translate would cause.
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Column(
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
              SizedBox(
                height: PortfolioConstants.navHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: AnimatedContainer(
                        duration: reduce
                            ? Duration.zero
                            : PortfolioMotion.of(context, PortfolioMotion.nav),
                        curve: Curves.easeOutCubic,
                        decoration: BoxDecoration(
                          color: PortfolioColors.background.withValues(
                            alpha: state.scrolled ? 0.94 : 0.0,
                          ),
                          border: Border(
                            bottom: BorderSide(
                              color: state.scrolled
                                  ? PortfolioColors.divider
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        child: PortfolioContainer(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: PortfolioConstants.navHeight,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _BrandButton(
                                  active: state.activeSection ==
                                      ShellSection.hero,
                                  onPressed: () =>
                                      onNavigate(ShellSection.hero),
                                ),
                                const Spacer(),
                                if (context.isMobile)
                                  _MobileMenu(onNavigate: onNavigate)
                                else
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      for (final section in const [
                                        ShellSection.work,
                                        ShellSection.about,
                                        ShellSection.contact,
                                      ]) ...[
                                        if (section != ShellSection.work)
                                          const SizedBox(width: 28),
                                        PortfolioLink(
                                          label: section.navLabel,
                                          active:
                                              state.activeSection == section,
                                          href: SectionRoutes.pathFor(section),
                                          onPressed: () => onNavigate(section),
                                        ),
                                      ],
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (onSkipToContent != null)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: _SkipLink(onActivated: onSkipToContent!),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SkipLink extends StatefulWidget {
  const _SkipLink({required this.onActivated});

  final VoidCallback onActivated;

  @override
  State<_SkipLink> createState() => _SkipLinkState();
}

class _SkipLinkState extends State<_SkipLink> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onShowFocusHighlight: (value) => setState(() => _focused = value),
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onActivated();
            return null;
          },
        ),
      },
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      child: ExcludeSemantics(
        excluding: !_focused,
        child: Semantics(
          button: true,
          label: 'Skip to content',
          excludeSemantics: true,
          child: IgnorePointer(
            ignoring: !_focused,
            child: AnimatedOpacity(
              opacity: _focused ? 1 : 0,
              duration: PortfolioMotion.of(context, PortfolioMotion.micro),
              child: Material(
                color: PortfolioColors.surfaceElevated,
                child: InkWell(
                  onTap: widget.onActivated,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Text(
                      'Skip to content',
                      style: PortfolioTypography.label().copyWith(
                        color: PortfolioColors.accent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandButton extends StatefulWidget {
  const _BrandButton({required this.active, required this.onPressed});

  final bool active;
  final VoidCallback onPressed;

  @override
  State<_BrandButton> createState() => _BrandButtonState();
}

class _BrandButtonState extends State<_BrandButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final href = SectionRoutes.pathFor(ShellSection.hero);

    return Link(
      uri: Uri.parse(href),
      target: LinkTarget.self,
      builder: (context, followLink) {
        return Semantics(
          button: true,
          link: true,
          selected: widget.active,
          label: 'Sajjad Ali, home',
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
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: _focused
                      ? Border.all(color: PortfolioColors.focusRing)
                      : null,
                ),
                child: SizedBox(
                  height: PortfolioConstants.navHeight,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Opacity(
                      opacity: widget.active || _hovered || _focused ? 1 : 0.88,
                      child: const PortfolioImage(
                        'branding/sajjad-ali-italic-logo-transparent.png',
                        width: 164,
                        height: 44,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft,
                        excludeFromSemantics: true,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MobileMenu extends StatelessWidget {
  const _MobileMenu({required this.onNavigate});

  final ValueChanged<ShellSection> onNavigate;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ShellSection>(
      tooltip: 'Menu',
      color: PortfolioColors.surfaceElevated,
      onSelected: (section) {
        // Restore focus to a sensible place after the menu closes.
        FocusManager.instance.primaryFocus?.unfocus();
        onNavigate(section);
      },
      onCanceled: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      itemBuilder: (context) => [
        for (final section in const [
          ShellSection.work,
          ShellSection.about,
          ShellSection.contact,
        ])
          PopupMenuItem(
            value: section,
            child: Text(section.navLabel),
          ),
      ],
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Text('Menu', style: PortfolioTypography.nav()),
        ),
      ),
    );
  }
}
