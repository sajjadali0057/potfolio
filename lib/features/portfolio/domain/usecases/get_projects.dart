import '../../../../core/usecases/use_case.dart';
import '../entities/project.dart';
import '../repositories/portfolio_repository.dart';

class GetProjects implements UseCase<List<Project>, NoParams> {
  GetProjects(this._repository);

  final PortfolioRepository _repository;

  @override
  Future<List<Project>> call(NoParams params) => _repository.getProjects();
}
