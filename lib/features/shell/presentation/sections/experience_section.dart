import 'package:flutter/material.dart';

import '../../../../app/theme/portfolio_colors.dart';
import '../../../../app/theme/portfolio_typography.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../presentation/widgets/section_band.dart';
import '../../../portfolio/domain/entities/profile.dart';

/// Standalone experience + education module.
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key, required this.profile, this.headingKey});

  final Profile profile;
  final Key? headingKey;

  @override
  Widget build(BuildContext context) {
    return SectionBand(
      color: PortfolioColors.sectionBandB,
      child: PortfolioContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: context.isMobile ? 48 : 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  key: headingKey,
                  'Experience',
                  style: PortfolioTypography.headlineLarge(context),
                ),
              ),
              const SizedBox(height: 28),
              for (final item in profile.experience)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: PortfolioColors.divider),
                    ),
                  ),
                  child: context.isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.period, style: PortfolioTypography.meta()),
                            const SizedBox(height: 12),
                            _Role(item: item),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 240,
                              child: Text(
                                item.period,
                                style: PortfolioTypography.meta(),
                              ),
                            ),
                            Expanded(child: _Role(item: item)),
                          ],
                        ),
                ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 64,
                runSpacing: 32,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Education',
                        style: PortfolioTypography.titleMedium(),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Bachelor of Computer Science',
                        style: PortfolioTypography.body(),
                      ),
                      Text(
                        'University of Lahore · 2017–2022',
                        style: PortfolioTypography.bodySmall(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Certifications',
                        style: PortfolioTypography.titleMedium(),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Flutter Development · Postman API Testing',
                        style: PortfolioTypography.body(),
                      ),
                      Text(
                        '10Pearls Pakistan · May 2024',
                        style: PortfolioTypography.bodySmall(),
                      ),
                    ],
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

class _Role extends StatelessWidget {
  const _Role({required this.item});

  final ExperienceItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.organization,
          style: PortfolioTypography.headlineSmall(context),
        ),
        const SizedBox(height: 8),
        Text(
          item.title,
          style: PortfolioTypography.titleMedium().copyWith(
            color: PortfolioColors.accent,
          ),
        ),
        const SizedBox(height: 12),
        Text(item.summary, style: PortfolioTypography.body()),
      ],
    );
  }
}
