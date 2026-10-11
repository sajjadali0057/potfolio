import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app/app.dart';
import 'app/di/injection_container.dart';
import 'app/theme/portfolio_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await preloadPortfolioFonts();

  if (kIsWeb) {
    usePathUrlStrategy();
  }

  await configureDependencies();

  runApp(const PortfolioApp());
}
