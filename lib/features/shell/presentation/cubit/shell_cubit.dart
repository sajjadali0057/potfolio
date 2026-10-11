import 'package:flutter_bloc/flutter_bloc.dart';

import 'shell_state.dart';

class ShellCubit extends Cubit<ShellState> {
  ShellCubit() : super(const ShellState());

  void setActiveSection(ShellSection section) {
    if (state.activeSection == section) return;
    emit(state.copyWith(activeSection: section));
  }

  void setScrolled(bool scrolled) {
    if (state.scrolled == scrolled) return;
    emit(state.copyWith(scrolled: scrolled));
  }
}
