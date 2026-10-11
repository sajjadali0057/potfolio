import 'package:equatable/equatable.dart';

class ExperienceItem extends Equatable {
  const ExperienceItem({
    required this.title,
    required this.organization,
    required this.period,
    required this.summary,
  });

  final String title;
  final String organization;
  final String period;
  final String summary;

  @override
  List<Object?> get props => [title, organization, period, summary];
}

class Profile extends Equatable {
  const Profile({
    required this.name,
    required this.headline,
    required this.intro,
    required this.body,
    required this.capabilities,
    required this.experience,
    required this.email,
    required this.linkedInUrl,
    required this.resumeUrl,
    required this.portraitUrl,
    required this.location,
  });

  final String name;
  final String headline;
  final String intro;
  final String body;
  final List<String> capabilities;
  final List<ExperienceItem> experience;
  final String email;
  final String linkedInUrl;
  final String resumeUrl;
  final String portraitUrl;
  final String location;

  @override
  List<Object?> get props => [
    name,
    headline,
    intro,
    body,
    capabilities,
    experience,
    email,
    linkedInUrl,
    resumeUrl,
    portraitUrl,
    location,
  ];
}
