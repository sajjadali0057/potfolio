import '../../features/shell/presentation/cubit/shell_state.dart';

/// Persists home scroll position across case-study navigations.
abstract final class HomeScrollMemory {
  static double? offset;
  static ShellSection? section;

  static void save({required double offset, required ShellSection section}) {
    HomeScrollMemory.offset = offset;
    HomeScrollMemory.section = section;
  }

  static void clear() {
    offset = null;
    section = null;
  }
}
