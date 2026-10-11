import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/di/injection_container.dart';
import '../../features/portfolio/presentation/cubit/case_study_cubit.dart';
import '../../features/portfolio/presentation/pages/case_study_page.dart';
import '../../features/shell/presentation/pages/home_shell_host.dart';
import '../utils/animations.dart';
import 'section_routes.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const work = SectionRoutes.work;
  static const about = SectionRoutes.about;
  static const contact = SectionRoutes.contact;
  static String caseStudy(String id) => '/work/$id';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return const HomeShellHost();
      },
      routes: [
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          builder: (context, state) => const SizedBox.shrink(),
        ),
        GoRoute(
          path: AppRoutes.work,
          name: 'work',
          builder: (context, state) => const SizedBox.shrink(),
        ),
        GoRoute(
          path: AppRoutes.about,
          name: 'about',
          builder: (context, state) => const SizedBox.shrink(),
        ),
        GoRoute(
          path: AppRoutes.contact,
          name: 'contact',
          builder: (context, state) => const SizedBox.shrink(),
        ),
      ],
    ),
    GoRoute(
      path: '/work/:id',
      name: 'case-study',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        final reduceMotion = WidgetsBinding
            .instance
            .platformDispatcher
            .accessibilityFeatures
            .disableAnimations;
        return CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: reduceMotion ? Duration.zero : PortfolioMotion.page,
          reverseTransitionDuration: reduceMotion
              ? Duration.zero
              : PortfolioMotion.page,
          child: BlocProvider(
            create: (_) => getIt<CaseStudyCubit>()..load(id),
            child: CaseStudyPage(projectId: id),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (prefersReducedMotion(context)) {
              return child;
            }
            final curved = CurvedAnimation(
              parent: animation,
              curve: motionEase,
            );
            return FadeTransition(opacity: curved, child: child);
          },
        );
      },
    ),
  ],
);
