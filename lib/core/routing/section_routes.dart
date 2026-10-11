import '../../features/shell/presentation/cubit/shell_state.dart';
import 'app_router.dart';

abstract final class SectionRoutes {
  static const work = '/work';
  static const about = '/about';
  static const contact = '/contact';

  static String pathFor(ShellSection section) => switch (section) {
    ShellSection.hero => AppRoutes.home,
    ShellSection.work => work,
    ShellSection.about => about,
    ShellSection.contact => contact,
  };

  static ShellSection? sectionFromPath(String path) {
    final normalized = path.endsWith('/') && path.length > 1
        ? path.substring(0, path.length - 1)
        : path;
    return switch (normalized) {
      AppRoutes.home || '/' => ShellSection.hero,
      work => ShellSection.work,
      about => ShellSection.about,
      contact => ShellSection.contact,
      _ => null,
    };
  }

  static bool isHomeShellPath(String path) {
    return sectionFromPath(path) != null;
  }
}
