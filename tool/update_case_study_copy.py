from pathlib import Path

path = Path("lib/features/portfolio/data/data_sources/portfolio_local_data_source.dart")
text = path.read_text(encoding="utf-8")

text = text.replace(
    """      coverAsset: 'images/portfolio/chatcash/chatcash-icon.jpg',
      imageAssets: const [
        'images/portfolio/chatcash/chatcash-icon.jpg',
        'images/portfolio/chatcash/full-hd/1709196962326.jpg',""",
    """      coverAsset: 'images/portfolio/chatcash/full-hd/1709196962326.jpg',
      imageAssets: const [
        'images/portfolio/chatcash/full-hd/1709196962326.jpg',
        'images/portfolio/chatcash/full-hd/1709196972418.jpg',""",
)

old_ann = """        designAnnotations: const [
          DesignAnnotation(
            imageAsset: 'images/portfolio/chatcash/chatcash-icon.jpg',
            caption: 'ChatCash app icon',
          ),
          DesignAnnotation(
            imageAsset:
                'images/portfolio/chatcash/full-hd/1709196962326.jpg',
            caption: 'ChatCash application screen 1',
          ),"""
new_ann = """        designAnnotations: const [
          DesignAnnotation(
            imageAsset:
                'images/portfolio/chatcash/full-hd/1709196962326.jpg',
            caption: 'Messaging and communication screen',
          ),"""
if old_ann in text:
    text = text.replace(old_ann, new_ann)
    # imageAssets still lists remaining screens; keep subsequent annotations as-is
    print("chatcash annotations updated")

replacements = [
    (
        """        outcomeSummary:
            'Led Flutter development work spanning content and market-data integrations, analytics, search and media playback.',
        challenge:
            'An Arabic-language cross-platform product for regional and global business and financial news.',""",
        """        outcomeSummary:
            'Cross-platform Flutter delivery spanning content feeds, market-data integrations, analytics, search and media playback.',
        challenge:
            'Present dense business and financial information clearly across Android and iOS while keeping content, market data and media features cohesive.',""",
    ),
    (
        """        outcomeSummary:
            'Contributed to the Flutter mobile experience, including media playback, content discovery and production application delivery.',
        challenge:
            'A cross-platform media experience for live and on-demand Arabic news, documentaries and business programming.',""",
        """        outcomeSummary:
            'Flutter mobile delivery for live and on-demand playback, content discovery and production release workflows.',
        challenge:
            'Support live and on-demand Arabic news programming with dependable playback and discoverable catalogues on mobile.',""",
    ),
    (
        """        outcomeSummary:
            'Developed OAuth-based authentication, receipt management and backend integration.',
        challenge:
            'A digital rewards application with secure receipt management and integrated account services.',""",
        """        outcomeSummary:
            'OAuth authentication, receipt management flows and backend-integrated account services on Flutter.',
        challenge:
            'Keep rewards account access and receipt submission secure while remaining straightforward for everyday use.',""",
    ),
    (
        """        outcomeSummary:
            'Contributed to the Flutter mobile experience, including media playback, content discovery, subscriptions and production application delivery.',
        challenge:
            'A subscription-based platform for live streams, VOD, podcasts and on-demand content from Pakistani journalist Imran Riaz Khan.',""",
        """        outcomeSummary:
            'Flutter delivery covering playback, discovery, subscriptions and production application release.',
        challenge:
            'Deliver subscription-gated live, VOD and podcast experiences with clear content discovery on mobile.',""",
    ),
    (
        """        outcomeSummary:
            'Engineered messaging and video calling with Agora SDK, encryption and monetization features.',
        challenge:
            'A communication application combining secure messaging, video calling and monetization features.',""",
        """        outcomeSummary:
            'Messaging and video calling with Agora SDK, encryption and monetization features on Flutter.',
        challenge:
            'Combine secure messaging, real-time calling and monetization without fragmenting the communication experience.',""",
    ),
    (
        """        outcomeSummary:
            'Worked on browsing, filtering, booking, account, notification and promotional engagement experiences.',
        challenge:
            'A Dubai-focused mobile product supporting vehicle discovery, rental and purchasing workflows.',""",
        """        outcomeSummary:
            'Vehicle browsing, filtering, booking, account, notification and promotional engagement experiences.',
        challenge:
            'Help users move from vehicle discovery to rental or purchase workflows in a Dubai-focused mobile product.',""",
    ),
    (
        """        outcomeSummary:
            'Built the cross-platform Flutter application, including expert discovery, networking flows and content features for industry professionals.',
        challenge:
            'A specialized Flutter platform for hairdressers to connect with industry experts, offering professional networking and knowledge exchange.',""",
        """        outcomeSummary:
            'Cross-platform Flutter application for expert discovery, professional networking and knowledge exchange.',
        challenge:
            'Connect hairdressing professionals with industry experts through discoverable profiles and knowledge-sharing flows.',""",
    ),
]

for old, new in replacements:
    if old not in text:
        print("MISSING:", old[:80].replace("\n", " "))
    else:
        text = text.replace(old, new)
        print("replaced ok")

for old, new in [
    ("caption: 'Asharq Business application screen 1'", "caption: 'Business news home and market context'"),
    ("caption: 'Asharq Business application screen 2'", "caption: 'Article and market-data reading experience'"),
    ("caption: 'Asharq Now application screen 1'", "caption: 'Live and on-demand media home'"),
    ("caption: 'Asharq Now application screen 2'", "caption: 'Programme discovery and playback'"),
    ("caption: 'RewardBee application screen 1'", "caption: 'Rewards home and account entry'"),
    ("caption: 'RewardBee application screen 2'", "caption: 'Receipt and rewards activity'"),
]:
    text = text.replace(old, new)

path.write_text(text, encoding="utf-8")
print("wrote", path)
