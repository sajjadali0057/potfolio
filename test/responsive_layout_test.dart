import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajjad_ali_portfolio/app/theme/portfolio_theme.dart';
import 'package:sajjad_ali_portfolio/features/portfolio/data/data_sources/profile_local_data_source.dart';
import 'package:sajjad_ali_portfolio/features/portfolio/data/data_sources/portfolio_local_data_source.dart';
import 'package:sajjad_ali_portfolio/features/shell/presentation/sections/hero_section.dart';
import 'package:sajjad_ali_portfolio/features/shell/presentation/sections/work_section.dart';
import 'package:sajjad_ali_portfolio/features/shell/presentation/sections/about_section.dart';
import 'package:sajjad_ali_portfolio/features/shell/presentation/sections/experience_section.dart';
import 'package:sajjad_ali_portfolio/features/shell/presentation/sections/contact_section.dart';
import 'package:sajjad_ali_portfolio/features/shell/presentation/sections/codewend_section.dart';

void main() {
  for (final width in [360.0, 768.0, 1440.0]) {
    testWidgets('portfolio sections fit at $width pixels', (tester) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final profile = const ProfileLocalDataSourceImpl().profile();
      final projects = const PortfolioLocalDataSourceImpl().projects();
      final sections = [
        HeroSection(onExploreWork: () {}, featuredProject: projects.first),
        const CodewendSection(),
        WorkSection(projects: projects),
        AboutSection(profile: profile),
        ExperienceSection(profile: profile),
        ContactSection(profile: profile),
      ];
      for (final section in sections) {
        await tester.pumpWidget(
          MaterialApp(
            theme: PortfolioTheme.dark(),
            home: Scaffold(body: SingleChildScrollView(child: section)),
          ),
        );
        await tester.pump(const Duration(milliseconds: 800));
        expect(
          tester.takeException(),
          isNull,
          reason: '${section.runtimeType} overflowed at $width',
        );
      }
    });
  }
}
