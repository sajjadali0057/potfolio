import '../../domain/entities/project.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../data_sources/portfolio_local_data_source.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  PortfolioRepositoryImpl(this._local);

  final PortfolioLocalDataSource _local;

  @override
  Future<List<Project>> getProjects() async => _local.projects();

  @override
  Future<Project?> getProjectById(String id) async => _local.projectById(id);
}
