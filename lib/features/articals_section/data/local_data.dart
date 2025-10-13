import 'package:sahifa/features/home/data/models/news_item_model.dart';

final Map<String, List<ArticalItemModel>> articlesByCategory = {
  'politics': [
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1495020689067-958852a7765e?w=400',
      title: 'Breaking Political News',
      description: 'New developments in the political landscape today',
      date: DateTime(2025, 10, 13),
      viewerCount: 15420,
    ),
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?w=400',
      title: 'International Summit Begins',
      description: 'World leaders gather to discuss global issues',
      date: DateTime(2025, 10, 12),
      viewerCount: 12300,
    ),
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1541872703-74c5e44368f9?w=400',
      title: 'Election Results Update',
      description: 'Latest poll numbers show surprising results',
      date: DateTime(2025, 10, 11),
      viewerCount: 18900,
    ),
  ],
  'sports': [
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1522869635100-9f4c5e86aa37?w=400',
      title: 'Championship Finals Tonight',
      description: 'Exciting match ends with unexpected result',
      date: DateTime(2025, 10, 13),
      viewerCount: 23500,
    ),
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=400',
      title: 'Summer Transfer Window',
      description: 'Major signings in the transfer market',
      date: DateTime(2025, 10, 11),
      viewerCount: 18900,
    ),
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=400',
      title: 'Olympic Qualifiers Begin',
      description: 'Athletes compete for their chance at glory',
      date: DateTime(2025, 10, 10),
      viewerCount: 14200,
    ),
  ],
  'technology': [
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=400',
      title: 'New Tech Update Released',
      description: 'Latest innovations in technology world',
      date: DateTime(2025, 10, 13),
      viewerCount: 8750,
    ),
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=400',
      title: 'AI Technology Advances',
      description: 'New techniques changing the industry future',
      date: DateTime(2025, 10, 12),
      viewerCount: 16200,
    ),
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1488590528505-98d2b5aba04b?w=400',
      title: 'Tech Giants Announce Partnership',
      description: 'Major collaboration in the tech industry',
      date: DateTime(2025, 10, 11),
      viewerCount: 11500,
    ),
  ],
  'business': [
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1586339949916-3e9457bef6d3?w=400',
      title: 'Market Analysis Today',
      description: 'Overview of financial markets performance',
      date: DateTime(2025, 10, 13),
      viewerCount: 12300,
    ),
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400',
      title: 'Stock Market Rally Continues',
      description: 'Investors remain optimistic about growth',
      date: DateTime(2025, 10, 12),
      viewerCount: 9800,
    ),
  ],
  'health': [
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=400',
      title: 'Health Tips for Winter',
      description: 'Your guide to staying healthy this season',
      date: DateTime(2025, 10, 13),
      viewerCount: 9500,
    ),
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?w=400',
      title: 'Medical Breakthrough Announced',
      description: 'Researchers discover new treatment method',
      date: DateTime(2025, 10, 12),
      viewerCount: 13400,
    ),
  ],
  'entertainment': [
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1478720568477-152d9b164e26?w=400',
      title: 'New Movies This Week',
      description: 'Latest cinema releases this weekend',
      date: DateTime(2025, 10, 13),
      viewerCount: 21400,
    ),
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=400',
      title: 'Music Festival Highlights',
      description: 'Best moments from the annual festival',
      date: DateTime(2025, 10, 11),
      viewerCount: 17800,
    ),
  ],
  'science': [
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=400',
      title: 'Space Exploration Update',
      description: 'New discoveries from deep space mission',
      date: DateTime(2025, 10, 13),
      viewerCount: 10200,
    ),
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1507413245164-6160d8298b31?w=400',
      title: 'Climate Research Findings',
      description: 'Scientists reveal important climate data',
      date: DateTime(2025, 10, 12),
      viewerCount: 8900,
    ),
  ],
  'world': [
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1526666923127-b2970f64b422?w=400',
      title: 'Global News Roundup',
      description: 'Today\'s most important world events',
      date: DateTime(2025, 10, 13),
      viewerCount: 19200,
    ),
    ArticalItemModel(
      imageUrl:
          'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=400',
      title: 'International Relations Update',
      description: 'Diplomatic developments around the world',
      date: DateTime(2025, 10, 12),
      viewerCount: 14600,
    ),
  ],
};
