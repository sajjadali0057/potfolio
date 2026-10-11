import '../../../../core/constants/portfolio_constants.dart';
import '../../domain/entities/profile.dart';

abstract class ProfileLocalDataSource {
  Profile profile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  const ProfileLocalDataSourceImpl();

  @override
  Profile profile() {
    return const Profile(
      name: PortfolioConstants.designerName,
      headline: 'From architecture to launch.',
      intro:
          'I am Sajjad Ali, Founder of CodeWend and a Senior Full Stack Flutter Developer based in Dubai, UAE. I bring 5+ years of experience delivering cross-platform applications across financial media, commerce and digital services.',
      body:
          'I build Android, iOS and web applications with Flutter and Dart, backed by Java Spring Boot services, REST/GraphQL APIs and PostgreSQL. My work spans financial media, OTT, commerce and on-demand products.\n\nI use Clean Architecture with BLoC/Cubit (and Provider/Riverpod where it fits) to keep applications maintainable, and integrate secure authentication with OAuth 2.0, Keycloak and UAE Pass. I ship with GitHub Actions and Azure DevOps — automating APK/AAB and IPA builds for Google Play and App Store — and work with Firebase, WooCommerce, payment gateways, Agora SDK, deep linking and push notifications.',
      capabilities: [
        'Mobile & web: Flutter, Dart, Android, iOS, React Native',
        'Architecture: Clean Architecture, MVVM, BLoC, Cubit, Provider, Riverpod, SOLID',
        'Backend & APIs: Java Spring Boot, REST, GraphQL, WebSockets, Firebase',
        'Data: PostgreSQL, SQLite, Hive, MongoDB, offline caching',
        'Security: OAuth 2.0, Keycloak, UAE Pass, encryption',
        'Integrations: WooCommerce, payment gateways, Agora SDK, deep linking, FCM',
        'Performance: profiling, lazy loading, caching, crash reduction',
        'Delivery: GitHub Actions, Azure DevOps, CI/CD, Play Store & App Store releases',
      ],
      experience: [
        ExperienceItem(
          title: 'Senior Full Stack Flutter Developer',
          organization: 'Evoteq, Dubai',
          period: 'April 2026 - Present',
          summary:
              'Developing Flutter web and mobile applications, Java Spring Boot backend services and integrated REST APIs for enterprise systems.',
        ),
        ExperienceItem(
          title: 'Senior Flutter Developer (Contract)',
          organization: 'Asharq News Network, Dubai',
          period: 'May 2025 - December 2025',
          summary:
              'Delivered financial media and streaming applications with Clean Architecture, secure APIs, offline caching, analytics and automated production deployments.',
        ),
        ExperienceItem(
          title: 'Senior Flutter Developer',
          organization: 'Global Innovative, Lahore',
          period: 'January 2022 - April 2025',
          summary:
              'Led mobile application delivery through Play Store and App Store deployment, improved performance, automated releases and mentored junior developers.',
        ),
        ExperienceItem(
          title: 'Flutter Developer',
          organization: 'Stellavant Technologies, Lahore',
          period: 'February 2021 - January 2022',
          summary:
              'Built Android and iOS applications using Flutter, BLoC and Provider, with REST APIs, local databases and modular architecture.',
        ),
      ],
      email: PortfolioConstants.email,
      linkedInUrl: PortfolioConstants.linkedIn,
      resumeUrl: PortfolioConstants.resumeUrl,
      portraitUrl: PortfolioConstants.portraitUrl,
      location: PortfolioConstants.location,
    );
  }
}
