import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajjad_ali_portfolio/features/portfolio/data/data_sources/portfolio_local_data_source.dart';

void main() {
  test(
    'catalog preserves CodeWend order, routes and existing gallery assets',
    () {
      const source = PortfolioLocalDataSourceImpl();
      final projects = source.projects();
      expect(projects.map((p) => p.id).toList(), [
        'asharq-business',
        'asharq-now',
        'rewardbee',
        'irk',
        'chatcash',
        'fastwheel',
        'creademic',
      ]);
      for (final project in projects) {
        expect(source.projectById(project.id), project);
        expect(project.imageAssets, isNotEmpty);
        for (final asset in project.imageAssets) {
          expect(File(asset).existsSync(), isTrue, reason: asset);
        }
      }
      expect(File('images/profile/sajjad-ali.png').existsSync(), isTrue);
    },
  );
}
