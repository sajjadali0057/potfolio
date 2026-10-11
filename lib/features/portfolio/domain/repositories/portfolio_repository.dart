import '../entities/project.dart';

abstract class PortfolioRepository {
  Future<List<Project>> getProjects();
  Future<Project?> getProjectById(String id);
}
