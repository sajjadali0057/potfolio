import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/use_case.dart';
import '../../domain/usecases/get_projects.dart';
import 'portfolio_state.dart';

class PortfolioCubit extends Cubit<PortfolioState> {
  PortfolioCubit(this._getProjects) : super(const PortfolioLoading());

  final GetProjects _getProjects;

  Future<void> load() async {
    try {
      final projects = await _getProjects(const NoParams());
      emit(PortfolioReady(projects));
    } catch (error) {
      emit(PortfolioFailure(error.toString()));
    }
  }
}
