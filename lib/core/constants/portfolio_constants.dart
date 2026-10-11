/// Site-wide identity and contact constants for Sajjad Ali's portfolio.
abstract final class PortfolioConstants {
  static const String designerName = 'Sajjad Ali';
  static const String pageTitle = 'Sajjad Ali · Portfolio';
  static const String metaDescription =
      'Sajjad Ali — Founder of CodeWend and Senior Full Stack Flutter Developer in Dubai. Flutter, Java Spring Boot, PostgreSQL and Azure DevOps.';

  static const String email = 'sajjadali0057@gmail.com';
  static const String linkedIn =
      'https://www.linkedin.com/in/sajjad-ali-developer/';
  static const String resumeUrl = 'resume/Sajjad_Ali_Resume.pdf';

  static const String portraitUrl =
      'https://unavatar.io/linkedin/sajjad-ali-developer';

  static const String location = 'Dubai, United Arab Emirates';

  static const String codeWendName = 'CodeWend';
  static const String codeWendUrl = 'https://codewend.com';
  static const String codeWendTagline =
      'UAE-based software consultancy for mobile, web and backend products.';

  static const double maxContentWidth = 1240;
  static const double navHeight = 56;

  /// Decorative gap above the navbar after the user scrolls away from the top.
  static const double navTopSpacing = 20;

  /// Extra reading clearance below the fixed nav when scrolling to a section.
  static const double sectionScrollClearance = 24;

  /// Enter the scrolled navbar state above this offset.
  static const double scrollEnterThreshold = 24;

  /// Leave the scrolled navbar state below this offset (hysteresis).
  static const double scrollExitThreshold = 8;

  static const double imageRadius = 8;
  static const double minTapTarget = 44;

  /// Nominal scrolled clearance used by tests and non-context call sites.
  /// Equals nav height + decorative gap + reading clearance (no safe-area).
  static double get sectionScrollOffset =>
      navHeight + navTopSpacing + sectionScrollClearance;

  /// System safe-area inset only — never includes decorative navbar spacing.
  static double safeAreaTop(double mediaQueryTop) => mediaQueryTop;

  /// Occupied overlay height at scroll offset zero (safe area + bar).
  static double navOccupiedAtTop(double mediaQueryTop) =>
      safeAreaTop(mediaQueryTop) + navHeight;

  /// Occupied overlay height once the scrolled gap is applied.
  static double navOccupiedScrolled(double mediaQueryTop) =>
      safeAreaTop(mediaQueryTop) + navTopSpacing + navHeight;

  /// Pixel clearance for section destinations under the scrolled navbar.
  static double sectionScrollClearanceTotal(double mediaQueryTop) =>
      navOccupiedScrolled(mediaQueryTop) + sectionScrollClearance;

  @Deprecated('Use safeAreaTop — decorative gap is animated, not permanent.')
  static double safeTopInset(double mediaQueryTop) => safeAreaTop(mediaQueryTop);
}

/// Layout spacing tokens on an 8pt rhythm.
abstract final class PortfolioSpacing {
  static const double xs = 8;
  static const double sm = 16;
  static const double md = 24;
  static const double lg = 40;
  static const double xl = 64;
  static const double xxl = 96;
  static const double section = 120;

  static const double pageGutterMobile = 20;
  static const double pageGutterTablet = 32;
  static const double pageGutterDesktop = 48;
}

/// Asset paths for portfolio imagery.
abstract final class PortfolioAssets {
  static const asharqBusiness = <String>[
    'images/portfolio/asharq-business/Screenshot_20260211_063726_LinkedIn.png',
    'images/portfolio/asharq-business/Screenshot_20260211_063755_Google_Play_Store.png',
    'images/portfolio/asharq-business/Screenshot_20260211_063807_Google_Play_Store.png',
    'images/portfolio/asharq-business/Screenshot_20260211_063818_Google_Play_Store.png',
    'images/portfolio/asharq-business/Screenshot_20260211_063829_Google_Play_Store.png',
    'images/portfolio/asharq-business/Screenshot_20260211_063648_LinkedIn.png',
  ];

  static const fastWheel = <String>[
    'images/portfolio/fastwheel/1727597753957.jpg',
    'images/portfolio/fastwheel/1727597706058.jpg',
    'images/portfolio/fastwheel/1727597728419.jpg',
    'images/portfolio/fastwheel/1727597763774.jpg',
    'images/portfolio/fastwheel/1727597777229.jpg',
    'images/portfolio/fastwheel/1727597796234.jpg',
  ];

  static const creademic = <String>[
    'images/portfolio/creademic/creademic01.jpg',
    'images/portfolio/creademic/creademic02.jpg',
    'images/portfolio/creademic/creademic03.jpg',
    'images/portfolio/creademic/creademic04.jpg',
    'images/portfolio/creademic/creademic05.jpg',
  ];

  static const irk = <String>[
    'images/portfolio/irk/irk01.png',
    'images/portfolio/irk/irk02.png',
    'images/portfolio/irk/irk03.png',
    'images/portfolio/irk/irk04.png',
    'images/portfolio/irk/irk05.png',
  ];
}
