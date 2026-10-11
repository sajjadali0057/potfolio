import 'package:equatable/equatable.dart';

import '../../domain/entities/project.dart';

sealed class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object?> get props => [];
}

final class PortfolioLoading extends PortfolioState {
  const PortfolioLoading();
}

final class PortfolioReady extends PortfolioState {
  const PortfolioReady(this.projects);

  final List<Project> projects;

  @override
  List<Object?> get props => [projects];
}

final class PortfolioFailure extends PortfolioState {
  const PortfolioFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
