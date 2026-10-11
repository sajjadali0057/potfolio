import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/use_case.dart';
import '../../domain/entities/project.dart';
import '../../domain/usecases/get_project_by_id.dart';
import '../../domain/usecases/get_projects.dart';
import 'case_study_state.dart';

class CaseStudyCubit extends Cubit<CaseStudyState> {
  CaseStudyCubit(this._getProjectById, this._getProjects)
    : super(const CaseStudyLoading());

  final GetProjectById _getProjectById;
  final GetProjects _getProjects;

  Future<void> load(String id) async {
    emit(const CaseStudyLoading());
    final project = await _getProjectById(id);
    if (project == null) {
      emit(CaseStudyMissing(id));
      return;
    }
    final all = await _getProjects(const NoParams());
    emit(
      CaseStudyReady(
        project: project,
        nextProject: _nextProject(all, id),
      ),
    );
  }

  void setSection(CaseStudySection section) {
    final current = state;
    if (current is CaseStudyReady) {
      emit(current.copyWith(activeSection: section));
    }
  }

  Project? _nextProject(List<Project> all, String id) {
    if (all.isEmpty) return null;
    final index = all.indexWhere((project) => project.id == id);
    if (index < 0) return all.first;
    return all[(index + 1) % all.length];
  }
}
