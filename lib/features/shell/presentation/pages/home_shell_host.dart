import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection_container.dart';
import '../../../../core/routing/section_routes.dart';
import '../../../portfolio/presentation/cubit/portfolio_cubit.dart';
import '../../../portfolio/presentation/cubit/profile_cubit.dart';
import '../cubit/shell_cubit.dart';
import '../cubit/shell_state.dart';
import 'home_page.dart';

/// Keeps home Cubits and scroll state alive while section URLs change.
class HomeShellHost extends StatefulWidget {
  const HomeShellHost({super.key});

  @override
  State<HomeShellHost> createState() => _HomeShellHostState();
}

class _HomeShellHostState extends State<HomeShellHost> {
  late final ShellCubit _shellCubit = getIt<ShellCubit>();
  late final PortfolioCubit _portfolioCubit = getIt<PortfolioCubit>()..load();
  late final ProfileCubit _profileCubit = getIt<ProfileCubit>()..load();

  @override
  void dispose() {
    _shellCubit.close();
    _portfolioCubit.close();
    _profileCubit.close();
    super.dispose();
  }

  ShellSection _sectionFromLocation(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    return SectionRoutes.sectionFromPath(path) ?? ShellSection.hero;
  }

  @override
  Widget build(BuildContext context) {
    final section = _sectionFromLocation(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _shellCubit),
        BlocProvider.value(value: _portfolioCubit),
        BlocProvider.value(value: _profileCubit),
      ],
      child: HomePage(initialSection: section),
    );
  }
}
