import 'package:equatable/equatable.dart';

enum ProjectLayoutRole { flagship, product, identity, experimental }

class ProjectDecision extends Equatable {
  const ProjectDecision({
    required this.title,
    required this.choice,
    required this.alternative,
    required this.reasoning,
  });

  final String title;
  final String choice;
  final String alternative;
  final String reasoning;

  @override
  List<Object?> get props => [title, choice, alternative, reasoning];
}

/// One gallery item: asset, caption, and optional accessible description.
class DesignAnnotation extends Equatable {
  const DesignAnnotation({
    required this.imageAsset,
    required this.caption,
    this.semanticDescription,
  });

  final String imageAsset;
  final String caption;
  final String? semanticDescription;

  String get accessibleLabel =>
      (semanticDescription ?? caption).trim().isEmpty ? caption : (semanticDescription ?? caption);

  @override
  List<Object?> get props => [imageAsset, caption, semanticDescription];
}

class CaseStudy extends Equatable {
  const CaseStudy({
    required this.purpose,
    required this.role,
    required this.collaborators,
    required this.timeline,
    required this.outcomeSummary,
    required this.challenge,
    required this.learned,
    required this.decisions,
    required this.designAnnotations,
    required this.outcomeDetail,
    required this.contributionNote,
  });

  final String purpose;
  final String role;
  final String collaborators;
  final String timeline;
  final String outcomeSummary;
  final String challenge;
  final List<String> learned;
  final List<ProjectDecision> decisions;
  final List<DesignAnnotation> designAnnotations;
  final String outcomeDetail;
  final String contributionNote;

  @override
  List<Object?> get props => [
    purpose,
    role,
    collaborators,
    timeline,
    outcomeSummary,
    challenge,
    learned,
    decisions,
    designAnnotations,
    outcomeDetail,
    contributionNote,
  ];
}

class Project extends Equatable {
  const Project({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.role,
    required this.discipline,
    required this.year,
    required this.coverAsset,
    required this.imageAssets,
    required this.layoutRole,
    required this.caseStudy,
  });

  final String id;
  final String name;
  final String shortDescription;
  final String role;
  final String discipline;
  final String year;
  final String coverAsset;
  final List<String> imageAssets;
  final ProjectLayoutRole layoutRole;
  final CaseStudy caseStudy;

  String get metaLine =>
      [role, discipline, year].where((value) => value.isNotEmpty).join(' · ');

  /// Gallery assets derived from annotations when present, else [imageAssets].
  List<String> get galleryAssets {
    final annotated = caseStudy.designAnnotations
        .map((item) => item.imageAsset)
        .where((path) => path.isNotEmpty)
        .toList(growable: false);
    if (annotated.isNotEmpty) return annotated;
    return imageAssets;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    shortDescription,
    role,
    discipline,
    year,
    coverAsset,
    imageAssets,
    layoutRole,
    caseStudy,
  ];
}
