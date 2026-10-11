import 'package:get_it/get_it.dart';

import '../../features/portfolio/data/data_sources/portfolio_local_data_source.dart';
import '../../features/portfolio/data/data_sources/profile_local_data_source.dart';
import '../../features/portfolio/data/repositories/portfolio_repository_impl.dart';
import '../../features/portfolio/data/repositories/profile_repository_impl.dart';
import '../../features/portfolio/domain/repositories/portfolio_repository.dart';
import '../../features/portfolio/domain/repositories/profile_repository.dart';
import '../../features/portfolio/domain/usecases/get_profile.dart';
import '../../features/portfolio/domain/usecases/get_project_by_id.dart';
import '../../features/portfolio/domain/usecases/get_projects.dart';
import '../../features/portfolio/presentation/cubit/case_study_cubit.dart';
import '../../features/portfolio/presentation/cubit/portfolio_cubit.dart';
import '../../features/portfolio/presentation/cubit/profile_cubit.dart';
import '../../features/shell/presentation/cubit/shell_cubit.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  if (getIt.isRegistered<PortfolioRepository>()) {
    await getIt.reset();
  }

  getIt
    ..registerLazySingleton<PortfolioLocalDataSource>(
      () => const PortfolioLocalDataSourceImpl(),
    )
    ..registerLazySingleton<ProfileLocalDataSource>(
      () => const ProfileLocalDataSourceImpl(),
    )
    ..registerLazySingleton<PortfolioRepository>(
      () => PortfolioRepositoryImpl(getIt<PortfolioLocalDataSource>()),
    )
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(getIt<ProfileLocalDataSource>()),
    )
    ..registerLazySingleton(() => GetProjects(getIt<PortfolioRepository>()))
    ..registerLazySingleton(() => GetProjectById(getIt<PortfolioRepository>()))
    ..registerLazySingleton(() => GetProfile(getIt<ProfileRepository>()))
    ..registerFactory(() => ShellCubit())
    ..registerFactory(() => PortfolioCubit(getIt<GetProjects>()))
    ..registerFactory(() => ProfileCubit(getIt<GetProfile>()))
    ..registerFactory(
      () => CaseStudyCubit(getIt<GetProjectById>(), getIt<GetProjects>()),
    );
}
