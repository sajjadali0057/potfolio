import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/portfolio_buttons.dart';
import '../../../../app/theme/portfolio_colors.dart';
import '../../../../app/theme/portfolio_typography.dart';
import '../../../../core/constants/portfolio_constants.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../presentation/widgets/section_band.dart';
import '../../../portfolio/domain/entities/profile.dart';

/// About module — bio and capabilities only (experience is a separate section).
class AboutSection extends StatelessWidget {
  const AboutSection({super.key, required this.profile, this.headingKey});

  final Profile profile;
  final Key? headingKey;

  Future<void> _open(BuildContext context, Uri uri, String failure) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bio = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            key: headingKey,
            'Engineering expertise. Founder perspective.',
            style: PortfolioTypography.headlineLarge(context),
          ),
        ),
        const SizedBox(height: 24),
        Text(profile.intro, style: PortfolioTypography.bodyLarge()),
        const SizedBox(height: 20),
        Text(
          'As Founder of CodeWend, a UAE-based software consultancy for mobile, web and backend products, I bring an engineering perspective to product development — connecting business requirements with clear technical decisions. My focus is on maintainable software, dependable integrations and a disciplined path from development to production.',
          style: PortfolioTypography.body(),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            TextButton(
              style: PortfolioButtons.text(),
              onPressed: () => _open(
                context,
                Uri.parse(PortfolioConstants.codeWendUrl),
                'Could not open codewend.com.',
              ),
              child: const Text('Visit codewend.com'),
            ),
            TextButton(
              style: PortfolioButtons.text(),
              onPressed: () => _open(
                context,
                Uri.base.resolve(profile.resumeUrl),
                'Could not open the resume.',
              ),
              child: const Text('Read my resume'),
            ),
          ],
        ),
      ],
    );

    final skills = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            'What I work with',
            style: PortfolioTypography.headlineSmall(context),
          ),
        ),
        const SizedBox(height: 24),
        for (final skill in profile.capabilities)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill.split(':').first,
                  style: PortfolioTypography.titleMedium().copyWith(
                    color: PortfolioColors.accent,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  skill.contains(':')
                      ? skill.substring(skill.indexOf(':') + 1).trim()
                      : skill,
                  style: PortfolioTypography.body(),
                ),
              ],
            ),
          ),
      ],
    );

    return SectionBand(
      color: PortfolioColors.sectionBandA,
      child: PortfolioContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: context.isMobile ? 48 : 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!context.isDesktop) ...[
                bio,
                const SizedBox(height: 40),
                skills,
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: bio),
                    const SizedBox(width: 96),
                    Expanded(child: skills),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
