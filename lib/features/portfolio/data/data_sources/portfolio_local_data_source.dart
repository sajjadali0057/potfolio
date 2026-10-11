import '../../domain/entities/project.dart';

abstract class PortfolioLocalDataSource {
  List<Project> projects();
  Project? projectById(String id);
}

class PortfolioLocalDataSourceImpl implements PortfolioLocalDataSource {
  const PortfolioLocalDataSourceImpl();

  static const List<Project> _catalog = [
    Project(
      id: 'asharq-business',
      name: 'Asharq Business',
      shortDescription:
          'An Arabic-language cross-platform product for regional and global business and financial news.',
      role: 'Flutter Development',
      discipline: 'News, Media & Financial Information',
      year: '',
      coverAsset:
          'images/portfolio/asharq-business/Screenshot_20260211_063726_LinkedIn.png',
      imageAssets: [
        'images/portfolio/asharq-business/Screenshot_20260211_063726_LinkedIn.png',
        'images/portfolio/asharq-business/Screenshot_20260211_063755_Google_Play_Store.png',
        'images/portfolio/asharq-business/Screenshot_20260211_063818_Google_Play_Store.png',
        'images/portfolio/asharq-business/Screenshot_20260211_063807_Google_Play_Store.png',
        'images/portfolio/asharq-business/Screenshot_20260211_063829_Google_Play_Store.png',
        'images/portfolio/asharq-business/Screenshot_20260211_063700_LinkedIn.png',
        'images/portfolio/asharq-business/Screenshot_20260211_063648_LinkedIn.png',
        'images/portfolio/asharq-business/Screenshot_20260211_063711_LinkedIn.png',
        'images/portfolio/asharq-business/Screenshot_20260211_063734_LinkedIn.png',
        'images/portfolio/asharq-business/Screenshot_20260211_063631_LinkedIn.png',
      ],
      layoutRole: ProjectLayoutRole.product,
      caseStudy: CaseStudy(
        purpose:
            'An Arabic-language cross-platform product for regional and global business and financial news.',
        role:
            'Led Flutter development work spanning content and market-data integrations, analytics, search and media playback.',
        collaborators: 'Product and engineering teams',
        timeline: '',
        outcomeSummary:
            'Shipped content feeds, market-data surfaces, analytics, search and media playback on Flutter for Android and iOS.',
        challenge:
            'Present dense business and financial information clearly across Android and iOS while keeping content, market data and media features cohesive.',
        learned: [],
        decisions: [],
        designAnnotations: [
          DesignAnnotation(
            imageAsset:
                'images/portfolio/asharq-business/Screenshot_20260211_063726_LinkedIn.png',
            caption: 'Business news home with live badge and market tickers',
            semanticDescription:
                'Phone mockup of the Asharq Business home feed with a live badge and market tickers',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/asharq-business/Screenshot_20260211_063755_Google_Play_Store.png',
            caption: 'Latest news list and currency context',
            semanticDescription:
                'Application screens showing a latest-news list and a markets-style asset list',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/asharq-business/Screenshot_20260211_063818_Google_Play_Store.png',
            caption: 'Story reading, markets and trending surfaces',
            semanticDescription:
                'Marketing composition of home story, markets list and trending crypto screens',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/asharq-business/Screenshot_20260211_063807_Google_Play_Store.png',
            caption: 'Article bookmarking on a markets chart screen',
            semanticDescription:
                'Marketing artwork highlighting bookmark states over a markets chart screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/asharq-business/Screenshot_20260211_063829_Google_Play_Store.png',
            caption: 'Home-screen news and market widgets',
            semanticDescription:
                'Marketing artwork of customizable news and market home-screen widgets',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/asharq-business/Screenshot_20260211_063700_LinkedIn.png',
            caption: 'Marketing art for alternate browsing styles',
            semanticDescription:
                'Promotional artwork describing scroll, flip and list browsing modes',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/asharq-business/Screenshot_20260211_063648_LinkedIn.png',
            caption: 'Marketing art for news and market widgets',
            semanticDescription:
                'Promotional artwork showing floating news and market index widgets',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/asharq-business/Screenshot_20260211_063711_LinkedIn.png',
            caption: 'Marketing art for live broadcast viewing',
            semanticDescription:
                'Promotional artwork for live television and special-event broadcast viewing',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/asharq-business/Screenshot_20260211_063734_LinkedIn.png',
            caption: 'Marketing art for personalized article feeds',
            semanticDescription:
                'Promotional artwork for interest-based article and news feeds',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/asharq-business/Screenshot_20260211_063631_LinkedIn.png',
            caption: 'Asharq Business with Bloomberg brand mark',
            semanticDescription:
                'Asharq Business and Bloomberg partnership logo lockup',
          ),
        ],
        outcomeDetail: 'Flutter, Dart, REST APIs, Firebase Analytics.',
        contributionNote:
            'This project is part of my professional experience. Its inclusion does not imply it was commissioned through CodeWend.',
      ),
    ),
    Project(
      id: 'asharq-now',
      name: 'Asharq Now',
      shortDescription:
          'A cross-platform media experience for live and on-demand Arabic news, documentaries and business programming.',
      role: 'Flutter Development',
      discipline: 'Streaming Media & News',
      year: '',
      coverAsset:
          'images/portfolio/asharq-now/Screenshot_20260211_062908_LinkedIn.png',
      imageAssets: [
        'images/portfolio/asharq-now/Screenshot_20260211_062908_LinkedIn.png',
        'images/portfolio/asharq-now/Screenshot_20260211_062918_LinkedIn.png',
        'images/portfolio/asharq-now/Screenshot_20260211_062922_LinkedIn.png',
        'images/portfolio/asharq-now/Screenshot_20260211_062927_LinkedIn.png',
        'images/portfolio/asharq-now/Screenshot_20260211_062931_LinkedIn.png',
        'images/portfolio/asharq-now/Screenshot_20260211_062937_LinkedIn.png',
        'images/portfolio/asharq-now/Screenshot_20260211_062941_LinkedIn.png',
        'images/portfolio/asharq-now/Screenshot_20260211_062857_LinkedIn.png',
      ],
      layoutRole: ProjectLayoutRole.product,
      caseStudy: CaseStudy(
        purpose:
            'A cross-platform media experience for live and on-demand Arabic news, documentaries and business programming.',
        role:
            'Contributed to the Flutter mobile experience, including media playback, content discovery and production application delivery.',
        collaborators: 'Product and engineering teams',
        timeline: '',
        outcomeSummary:
            'Delivered live and on-demand playback, content discovery and production release workflows on Flutter.',
        challenge:
            'Support live and on-demand Arabic news programming with dependable playback and discoverable catalogues on mobile.',
        learned: [],
        decisions: [],
        designAnnotations: [
          DesignAnnotation(
            imageAsset:
                'images/portfolio/asharq-now/Screenshot_20260211_062908_LinkedIn.png',
            caption: 'Podcast episode list with mini player',
            semanticDescription:
                'Asharq Now podcast list screen with an active mini player and bottom navigation',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/asharq-now/Screenshot_20260211_062918_LinkedIn.png',
            caption: 'Lock-screen podcast playback controls',
            semanticDescription:
                'System lock-screen media controls playing an Asharq podcast episode',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/asharq-now/Screenshot_20260211_062922_LinkedIn.png',
            caption: 'Asharq Now application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/asharq-now/Screenshot_20260211_062927_LinkedIn.png',
            caption: 'Asharq Now application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/asharq-now/Screenshot_20260211_062931_LinkedIn.png',
            caption: 'Asharq Now application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/asharq-now/Screenshot_20260211_062937_LinkedIn.png',
            caption: 'Asharq Now application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/asharq-now/Screenshot_20260211_062941_LinkedIn.png',
            caption: 'Asharq Now application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/asharq-now/Screenshot_20260211_062857_LinkedIn.png',
            caption: 'Asharq Now brand mark',
            semanticDescription:
                'Asharq Now logo in Arabic and English with red accent dots',
          ),
        ],
        outcomeDetail: 'Flutter, Dart, video streaming, Firebase Analytics.',
        contributionNote:
            'This project is part of my professional experience. Its inclusion does not imply it was commissioned through CodeWend.',
      ),
    ),
    Project(
      id: 'rewardbee',
      name: 'RewardBee',
      shortDescription:
          'A digital rewards application with secure receipt management and integrated account services.',
      role: 'Flutter Development',
      discipline: 'Rewards Platform',
      year: '',
      coverAsset:
          'images/portfolio/rewardbee/Screenshot_20260211_062657_LinkedIn.png',
      imageAssets: [
        'images/portfolio/rewardbee/Screenshot_20260211_062657_LinkedIn.png',
        'images/portfolio/rewardbee/Screenshot_20260211_062700_LinkedIn.png',
        'images/portfolio/rewardbee/Screenshot_20260211_062703_LinkedIn.png',
        'images/portfolio/rewardbee/Screenshot_20260211_062707_LinkedIn.png',
      ],
      layoutRole: ProjectLayoutRole.product,
      caseStudy: CaseStudy(
        purpose:
            'A digital rewards application with secure receipt management and integrated account services.',
        role:
            'Developed OAuth-based authentication, receipt management and backend integration.',
        collaborators: 'Product and engineering teams',
        timeline: '',
        outcomeSummary:
            'Implemented OAuth sign-in, receipt submission flows and backend-integrated account services on Flutter.',
        challenge:
            'Keep rewards account access and receipt submission secure while remaining straightforward for everyday use.',
        learned: [],
        decisions: [],
        designAnnotations: [
          DesignAnnotation(
            imageAsset:
                'images/portfolio/rewardbee/Screenshot_20260211_062657_LinkedIn.png',
            caption: 'Marketing art featuring the rewards program picker',
            semanticDescription:
                'RewardBee promotional artwork showing a phone with the rewards program picker UI',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/rewardbee/Screenshot_20260211_062700_LinkedIn.png',
            caption: 'RewardBee application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/rewardbee/Screenshot_20260211_062703_LinkedIn.png',
            caption: 'RewardBee application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/rewardbee/Screenshot_20260211_062707_LinkedIn.png',
            caption: 'RewardBee application screen',
          ),
        ],
        outcomeDetail: 'Flutter, Dart, OAuth, REST APIs.',
        contributionNote:
            'This project is part of my professional experience. Its inclusion does not imply it was commissioned through CodeWend.',
      ),
    ),
    Project(
      id: 'irk',
      name: 'IRK',
      shortDescription:
          'A subscription-based platform for live streams, VOD, podcasts and on-demand content from Pakistani journalist Imran Riaz Khan.',
      role: 'Flutter Development',
      discipline: 'Media Streaming & Subscription Content',
      year: '',
      coverAsset: 'images/portfolio/irk/irk01.png',
      imageAssets: [
        'images/portfolio/irk/irk01.png',
        'images/portfolio/irk/irk02.png',
        'images/portfolio/irk/irk03.png',
        'images/portfolio/irk/irk04.png',
        'images/portfolio/irk/irk05.png',
        'images/portfolio/irk/irk06.png',
        'images/portfolio/irk/irk07.png',
      ],
      layoutRole: ProjectLayoutRole.product,
      caseStudy: CaseStudy(
        purpose:
            'A subscription-based platform for live streams, VOD, podcasts and on-demand content from Pakistani journalist Imran Riaz Khan.',
        role:
            'Contributed to the Flutter mobile experience, including media playback, content discovery, subscriptions and production application delivery.',
        collaborators: 'Product and engineering teams',
        timeline: '',
        outcomeSummary:
            'Shipped playback, discovery, subscription gating and production application release on Flutter.',
        challenge:
            'Deliver subscription-gated live, VOD and podcast experiences with clear content discovery on mobile.',
        learned: [],
        decisions: [],
        designAnnotations: [
          DesignAnnotation(
            imageAsset: 'images/portfolio/irk/irk01.png',
            caption: 'IRK application screen',
          ),
          DesignAnnotation(
            imageAsset: 'images/portfolio/irk/irk02.png',
            caption: 'IRK application screen',
          ),
          DesignAnnotation(
            imageAsset: 'images/portfolio/irk/irk03.png',
            caption: 'IRK application screen',
          ),
          DesignAnnotation(
            imageAsset: 'images/portfolio/irk/irk04.png',
            caption: 'IRK application screen',
          ),
          DesignAnnotation(
            imageAsset: 'images/portfolio/irk/irk05.png',
            caption: 'IRK application screen',
          ),
          DesignAnnotation(
            imageAsset: 'images/portfolio/irk/irk06.png',
            caption: 'IRK application screen',
          ),
          DesignAnnotation(
            imageAsset: 'images/portfolio/irk/irk07.png',
            caption: 'IRK application screen',
          ),
        ],
        outcomeDetail: 'Flutter, Dart, video streaming, subscriptions.',
        contributionNote:
            'This project is part of my professional experience. Its inclusion does not imply it was commissioned through CodeWend.',
      ),
    ),
    Project(
      id: 'chatcash',
      name: 'ChatCash',
      shortDescription:
          'A communication application combining secure messaging, video calling and monetization features.',
      role: 'Flutter Development',
      discipline: 'Secure Messaging & Digital Transactions',
      year: '',
      coverAsset: 'images/portfolio/chatcash/full-hd/1709196962326.jpg',
      imageAssets: [
        'images/portfolio/chatcash/full-hd/1709196962326.jpg',
        'images/portfolio/chatcash/full-hd/1709196972418.jpg',
        'images/portfolio/chatcash/full-hd/1709196978760.jpg',
        'images/portfolio/chatcash/full-hd/1709196985583.jpg',
        'images/portfolio/chatcash/full-hd/1709196993961.jpg',
        'images/portfolio/chatcash/full-hd/1709197001001.jpg',
        'images/portfolio/chatcash/full-hd/1709197007681.jpg',
        'images/portfolio/chatcash/full-hd/1709197017150.jpg',
        'images/portfolio/chatcash/full-hd/1709197023423.jpg',
      ],
      layoutRole: ProjectLayoutRole.product,
      caseStudy: CaseStudy(
        purpose:
            'A communication application combining secure messaging, video calling and monetization features.',
        role:
            'Engineered messaging and video calling with Agora SDK, encryption and monetization features.',
        collaborators: 'Product and engineering teams',
        timeline: '',
        outcomeSummary:
            'Built messaging, Agora-powered video calling, encryption and monetization flows on Flutter.',
        challenge:
            'Combine secure messaging, real-time calling and monetization without fragmenting the communication experience.',
        learned: [],
        decisions: [],
        designAnnotations: [
          DesignAnnotation(
            imageAsset:
                'images/portfolio/chatcash/full-hd/1709196962326.jpg',
            caption: 'Messaging and communication screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/chatcash/full-hd/1709196972418.jpg',
            caption: 'ChatCash application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/chatcash/full-hd/1709196978760.jpg',
            caption: 'ChatCash application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/chatcash/full-hd/1709196985583.jpg',
            caption: 'ChatCash application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/chatcash/full-hd/1709196993961.jpg',
            caption: 'ChatCash application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/chatcash/full-hd/1709197001001.jpg',
            caption: 'ChatCash application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/chatcash/full-hd/1709197007681.jpg',
            caption: 'ChatCash application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/chatcash/full-hd/1709197017150.jpg',
            caption: 'ChatCash application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/chatcash/full-hd/1709197023423.jpg',
            caption: 'ChatCash application screen',
          ),
        ],
        outcomeDetail: 'Flutter, Dart, Agora SDK.',
        contributionNote:
            'This project is part of my professional experience. Its inclusion does not imply it was commissioned through CodeWend.',
      ),
    ),
    Project(
      id: 'fastwheel',
      name: 'FastWheel',
      shortDescription:
          'A Dubai-focused mobile product supporting vehicle discovery, rental and purchasing workflows.',
      role: 'Flutter Development',
      discipline: 'Automotive Commerce & Booking',
      year: '',
      coverAsset: 'images/portfolio/fastwheel/full-hd/1727597706058.jpg',
      imageAssets: [
        'images/portfolio/fastwheel/full-hd/1727597706058.jpg',
        'images/portfolio/fastwheel/full-hd/1727597728419.jpg',
        'images/portfolio/fastwheel/full-hd/1727597753957.jpg',
        'images/portfolio/fastwheel/full-hd/1727597763774.jpg',
        'images/portfolio/fastwheel/full-hd/1727597777229.jpg',
        'images/portfolio/fastwheel/full-hd/1727597796234.jpg',
        'images/portfolio/fastwheel/full-hd/1727597810153.jpg',
        'images/portfolio/fastwheel/full-hd/1727597827893.jpg',
      ],
      layoutRole: ProjectLayoutRole.product,
      caseStudy: CaseStudy(
        purpose:
            'A Dubai-focused mobile product supporting vehicle discovery, rental and purchasing workflows.',
        role:
            'Worked on browsing, filtering, booking, account, notification and promotional engagement experiences.',
        collaborators: 'Product and engineering teams',
        timeline: '',
        outcomeSummary:
            'Delivered vehicle browsing, filtering, booking, account, notification and promotional engagement flows.',
        challenge:
            'Help users move from vehicle discovery to rental or purchase workflows in a Dubai-focused mobile product.',
        learned: [],
        decisions: [],
        designAnnotations: [
          DesignAnnotation(
            imageAsset:
                'images/portfolio/fastwheel/full-hd/1727597706058.jpg',
            caption: 'FastWheel application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/fastwheel/full-hd/1727597728419.jpg',
            caption: 'FastWheel application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/fastwheel/full-hd/1727597753957.jpg',
            caption: 'FastWheel application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/fastwheel/full-hd/1727597763774.jpg',
            caption: 'FastWheel application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/fastwheel/full-hd/1727597777229.jpg',
            caption: 'FastWheel application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/fastwheel/full-hd/1727597796234.jpg',
            caption: 'FastWheel application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/fastwheel/full-hd/1727597810153.jpg',
            caption: 'FastWheel application screen',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/fastwheel/full-hd/1727597827893.jpg',
            caption: 'FastWheel application screen',
          ),
        ],
        outcomeDetail: 'Flutter, WooCommerce, push notifications.',
        contributionNote:
            'This project is part of my professional experience. Its inclusion does not imply it was commissioned through CodeWend.',
      ),
    ),
    Project(
      id: 'creademic',
      name: 'Creademic',
      shortDescription:
          'A specialized Flutter platform for hairdressers to connect with industry experts, offering professional networking and knowledge exchange.',
      role: 'Flutter Development',
      discipline: 'Professional Networking & Education',
      year: '',
      coverAsset: 'images/portfolio/creademic/creademic01.jpg',
      imageAssets: [
        'images/portfolio/creademic/creademic01.jpg',
        'images/portfolio/creademic/creademic02.jpg',
        'images/portfolio/creademic/creademic03.jpg',
        'images/portfolio/creademic/creademic04.jpg',
        'images/portfolio/creademic/creademic05.jpg',
      ],
      layoutRole: ProjectLayoutRole.product,
      caseStudy: CaseStudy(
        purpose:
            'A specialized Flutter platform for hairdressers to connect with industry experts, offering professional networking and knowledge exchange.',
        role:
            'Built the cross-platform Flutter application, including expert discovery, networking flows and content features for industry professionals.',
        collaborators: 'Product and engineering teams',
        timeline: '',
        outcomeSummary:
            'Shipped expert discovery, professional networking and knowledge-exchange features on Flutter.',
        challenge:
            'Connect hairdressing professionals with industry experts through discoverable profiles and knowledge-sharing flows.',
        learned: [],
        decisions: [],
        designAnnotations: [
          DesignAnnotation(
            imageAsset: 'images/portfolio/creademic/creademic01.jpg',
            caption: 'Creademic application screen',
          ),
          DesignAnnotation(
            imageAsset: 'images/portfolio/creademic/creademic02.jpg',
            caption: 'Creademic application screen',
          ),
          DesignAnnotation(
            imageAsset: 'images/portfolio/creademic/creademic03.jpg',
            caption: 'Creademic application screen',
          ),
          DesignAnnotation(
            imageAsset: 'images/portfolio/creademic/creademic04.jpg',
            caption: 'Creademic application screen',
          ),
          DesignAnnotation(
            imageAsset: 'images/portfolio/creademic/creademic05.jpg',
            caption: 'Creademic application screen',
          ),
        ],
        outcomeDetail: 'Flutter, Dart, REST APIs.',
        contributionNote:
            'This project is part of my professional experience. Its inclusion does not imply it was commissioned through CodeWend.',
      ),
    ),
  ];

  @override
  List<Project> projects() => List<Project>.unmodifiable(_catalog);

  @override
  Project? projectById(String id) {
    for (final project in _catalog) {
      if (project.id == id) return project;
    }
    return null;
  }
}
