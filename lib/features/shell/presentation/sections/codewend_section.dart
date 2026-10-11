import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/portfolio_colors.dart';
import '../../../../app/theme/portfolio_typography.dart';
import '../../../../core/constants/portfolio_constants.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../presentation/widgets/portfolio_image.dart';
import '../../../../presentation/widgets/portfolio_link.dart';

/// Compact band introducing CodeWend beneath the hero.
class CodewendSection extends StatelessWidget {
  const CodewendSection({super.key});

  static const _logoAsset = 'branding/codewend-wordmark.png';

  Future<void> _openSite() async {
    await launchUrl(
      Uri.parse(PortfolioConstants.codeWendUrl),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final logoHeight = context.isMobile ? 30.0 : 44.0;

    final copy = Container(
      color: PortfolioColors.sectionBandB,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FOUNDER OF ${PortfolioConstants.codeWendName.toUpperCase()}',
            style: PortfolioTypography.label().copyWith(
              color: PortfolioColors.accent,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          Semantics(
            label: PortfolioConstants.codeWendName,
            image: true,
            child: PortfolioImage(
              _logoAsset,
              height: logoHeight,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              semanticLabel: '${PortfolioConstants.codeWendName} logo',
              excludeFromSemantics: true,
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              PortfolioConstants.codeWendTagline,
              style: PortfolioTypography.body(),
            ),
          ),
        ],
      ),
    );

    final link = PortfolioLink(
      label: 'Visit codewend.com',
      style: PortfolioTypography.label(),
      onPressed: _openSite,
    );

    return PortfolioContainer(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 32),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: PortfolioColors.surface,
            border: Border.all(color: PortfolioColors.divider),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.isMobile ? 24 : 36,
              vertical: context.isMobile ? 28 : 32,
            ),
            child: context.isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [copy, const SizedBox(height: 16), link],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: copy),
                      const SizedBox(width: 32),
                      link,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
