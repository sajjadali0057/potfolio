import 'package:flutter/material.dart';

import '../core/constants/portfolio_constants.dart';
import '../core/routing/app_router.dart';
import 'theme/portfolio_theme.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: PortfolioConstants.pageTitle,
      debugShowCheckedModeBanner: false,
      theme: PortfolioTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
