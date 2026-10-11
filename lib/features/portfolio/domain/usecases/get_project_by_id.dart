import '../../../../core/usecases/use_case.dart';
import '../entities/project.dart';
import '../repositories/portfolio_repository.dart';

class GetProjectById implements UseCase<Project?, String> {
  GetProjectById(this._repository);

  final PortfolioRepository _repository;

  @override
  Future<Project?> call(String params) => _repository.getProjectById(params);
}
