import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/portfolio_buttons.dart';
import '../../../../app/theme/portfolio_colors.dart';
import '../../../../app/theme/portfolio_typography.dart';
import '../../../../core/constants/portfolio_constants.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../presentation/widgets/section_band.dart';
import '../../../portfolio/domain/entities/profile.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key, required this.profile, this.headingKey});

  final Profile profile;
  final Key? headingKey;

  Future<void> _email(BuildContext context) async {
    final uri = Uri(scheme: 'mailto', path: profile.email);
    final ok = await launchUrl(uri);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the email app.')),
      );
    }
  }

  Future<void> _linkedin(BuildContext context) async {
    final ok = await launchUrl(
      Uri.parse(profile.linkedInUrl),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open LinkedIn.')),
      );
    }
  }

  Future<void> _openUrl(
    BuildContext context,
    Uri uri,
    String failure,
  ) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure)),
      );
    }
  }

  Future<void> _copyEmail(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: profile.email));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Email copied: ${profile.email}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Colors intentionally left as currently configured.
    return SectionBand(
      color: PortfolioColors.sectionBandA,
      child: PortfolioContainer(
        child: Padding(
          padding: EdgeInsets.only(
            top: context.isMobile ? 32 : 48,
            bottom: 24 + MediaQuery.paddingOf(context).bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.isMobile ? 28 : 56),
                decoration: BoxDecoration(
                  color: PortfolioColors.sectionBandB,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        key: headingKey,
                        'Discuss your next digital product.',
                        style: PortfolioTypography.display(context).copyWith(
                          fontSize: context.isMobile
                              ? 32
                              : context.isTablet
                                  ? 44
                                  : 56,
                          height: 1.15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'For product development engagements, technical collaboration or senior engineering opportunities, please get in touch.',
                      style: PortfolioTypography.bodyLarge(),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        FilledButton(
                          onPressed: () => _email(context),
                          style: PortfolioButtons.primary(),
                          child: const Text('Email Sajjad'),
                        ),
                        OutlinedButton(
                          onPressed: () => _copyEmail(context),
                          style: PortfolioButtons.secondary(),
                          child: const Text('Copy email'),
                        ),
                        TextButton(
                          onPressed: () => _linkedin(context),
                          style: PortfolioButtons.text(),
                          child: const Text('LinkedIn'),
                        ),
                        TextButton(
                          onPressed: () => _openUrl(
                            context,
                            Uri.base.resolve(profile.resumeUrl),
                            'Could not open the resume.',
                          ),
                          style: PortfolioButtons.text(),
                          child: const Text('View resume'),
                        ),
                        TextButton(
                          onPressed: () => _openUrl(
                            context,
                            Uri.parse(PortfolioConstants.codeWendUrl),
                            'Could not open codewend.com.',
                          ),
                          style: PortfolioButtons.text(),
                          child: const Text('Visit CodeWend'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    const Divider(color: PortfolioColors.divider),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: context.isMobile ? 28 : 48,
                      runSpacing: 28,
                      children: [
                        _ContactItem(
                          label: 'Email',
                          value: profile.email,
                          onPressed: () => _email(context),
                        ),
                        _ContactItem(
                          label: 'LinkedIn',
                          value: 'sajjad-ali-developer',
                          onPressed: () => _linkedin(context),
                        ),
                        _ContactItem(
                          label: 'Location',
                          value: profile.location,
                        ),
                        _ContactItem(
                          label: 'Consultancy',
                          value: PortfolioConstants.codeWendName,
                          onPressed: () => _openUrl(
                            context,
                            Uri.parse(PortfolioConstants.codeWendUrl),
                            'Could not open codewend.com.',
                          ),
                        ),
                        _ContactItem(
                          label: 'Resume',
                          value: 'PDF download',
                          onPressed: () => _openUrl(
                            context,
                            Uri.base.resolve(profile.resumeUrl),
                            'Could not open the resume.',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 32,
                runSpacing: 12,
                children: [
                  Text(
                    '© ${DateTime.now().year} Sajjad Ali',
                    style: PortfolioTypography.bodySmall(),
                  ),
                  Text(profile.location, style: PortfolioTypography.bodySmall()),
                  Text(
                    PortfolioConstants.codeWendTagline,
                    style: PortfolioTypography.bodySmall(),
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

class _ContactItem extends StatelessWidget {
  const _ContactItem({
    required this.label,
    required this.value,
    this.onPressed,
  });

  final String label;
  final String value;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final valueStyle = PortfolioTypography.body().copyWith(
      color: PortfolioColors.textPrimary,
    );

    return SizedBox(
      width: context.isMobile ? double.infinity : 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: PortfolioTypography.meta()),
          const SizedBox(height: 8),
          if (onPressed != null)
            InkWell(
              onTap: onPressed,
              child: Text(
                value,
                style: valueStyle.copyWith(color: PortfolioColors.accent),
              ),
            )
          else
            SelectableText(value, style: valueStyle),
        ],
      ),
    );
  }
}
