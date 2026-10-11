import 'package:equatable/equatable.dart';

enum ShellSection { hero, work, about, contact }

extension ShellSectionX on ShellSection {
  String get label => switch (this) {
    ShellSection.hero => 'Home',
    ShellSection.work => 'Work',
    ShellSection.about => 'About',
    ShellSection.contact => 'Contact',
  };

  String get navLabel => switch (this) {
    ShellSection.hero => 'Home',
    ShellSection.work => 'Work',
    ShellSection.about => 'About',
    ShellSection.contact => 'Contact',
  };
}

class ShellState extends Equatable {
  const ShellState({
    this.activeSection = ShellSection.hero,
    this.scrolled = false,
  });

  final ShellSection activeSection;
  final bool scrolled;

  ShellState copyWith({ShellSection? activeSection, bool? scrolled}) {
    return ShellState(
      activeSection: activeSection ?? this.activeSection,
      scrolled: scrolled ?? this.scrolled,
    );
  }

  @override
  List<Object?> get props => [activeSection, scrolled];
}
