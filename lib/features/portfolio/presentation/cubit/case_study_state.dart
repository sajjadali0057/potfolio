import 'package:equatable/equatable.dart';

import '../../domain/entities/project.dart';

sealed class CaseStudyState extends Equatable {
  const CaseStudyState();

  @override
  List<Object?> get props => [];
}

final class CaseStudyLoading extends CaseStudyState {
  const CaseStudyLoading();
}

final class CaseStudyReady extends CaseStudyState {
  const CaseStudyReady({
    required this.project,
    this.activeSection = CaseStudySection.overview,
    this.nextProject,
  });

  final Project project;
  final CaseStudySection activeSection;
  final Project? nextProject;

  CaseStudyReady copyWith({
    CaseStudySection? activeSection,
    Project? nextProject,
  }) {
    return CaseStudyReady(
      project: project,
      activeSection: activeSection ?? this.activeSection,
      nextProject: nextProject ?? this.nextProject,
    );
  }

  @override
  List<Object?> get props => [project, activeSection, nextProject];
}

final class CaseStudyMissing extends CaseStudyState {
  const CaseStudyMissing(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

enum CaseStudySection {
  overview,
  role,
  decisions,
  screens,
  outcome,
}

extension CaseStudySectionX on CaseStudySection {
  String get label => switch (this) {
    CaseStudySection.overview => 'Overview',
    CaseStudySection.role => 'Role',
    CaseStudySection.decisions => 'Decisions',
    CaseStudySection.screens => 'Screens',
    CaseStudySection.outcome => 'Stack',
  };

  String get heading => switch (this) {
    CaseStudySection.overview => 'Product and audience',
    CaseStudySection.role => 'Personal role and scope',
    CaseStudySection.decisions => 'Constraints and decisions',
    CaseStudySection.screens => 'Selected screens',
    // Honest label when verified business outcomes are unavailable.
    CaseStudySection.outcome => 'Technologies',
  };
}

extension CaseStudyVisibility on CaseStudy {
  List<CaseStudySection> visibleSections() {
    final sections = <CaseStudySection>[CaseStudySection.overview];

    if (role.trim().isNotEmpty) {
      sections.add(CaseStudySection.role);
    }
    if (decisions.isNotEmpty || learned.isNotEmpty) {
      sections.add(CaseStudySection.decisions);
    }
    if (designAnnotations.isNotEmpty) {
      sections.add(CaseStudySection.screens);
    }
    if (outcomeDetail.trim().isNotEmpty ||
        outcomeSummary.trim().isNotEmpty ||
        contributionNote.trim().isNotEmpty) {
      sections.add(CaseStudySection.outcome);
    }
    return sections;
  }
}
