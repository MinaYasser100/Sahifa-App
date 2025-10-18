# Banners Architecture Documentation

## Overview
This document explains the architecture for fetching and displaying banners in the home screen.

## Architecture Flow

```
HomeView (BlocProvider)
    ↓
BannersCubit.fetchBanners()
    ↓
BannerRepoImpl.fetchBanners()
    ↓
Returns Either<String, List<ArticleItemModel>>
    ↓
BannersCubit emits state
    ↓
CustomBannerCarouselSection (BlocBuilder)
    ↓
Display banners in carousel
```

## Components

### 1. Data Layer (`banner_repo.dart`)

#### **BannerRepo** (Abstract Class)
- Defines the contract for fetching banners
- Method: `Future<Either<String, List<ArticleItemModel>>> fetchBanners()`

#### **BannerRepoImpl** (Implementation)
- Implements the actual fetching logic
- Currently uses **simulated API response** with 1-second delay
- Returns 5 sample banners with different categories
- **TODO**: Replace with actual API call when backend is ready

**Sample Response:**
```dart
[
  {
    id: 'banner_1',
    imageUrl: '...',
    title: 'Breaking: Major Economic Summit...',
    description: '...',
    date: DateTime,
    viewerCount: 15420
  },
  // ... 4 more banners
]
```

### 2. Business Logic Layer (`banners_cubit.dart`, `banners_state.dart`)

#### **BannersState** (Sealed Class)
- `BannersInitial` - Initial state
- `BannersLoading` - Loading banners from repo
- `BannersLoaded` - Successfully loaded banners
- `BannersError` - Error occurred with error message

#### **BannersCubit**
- Manages banner state
- **Methods:**
  - `fetchBanners()` - Fetch banners from repository
  - `refreshBanners()` - Refresh banner list
- Uses `isClosed` checks to prevent emitting after disposal

### 3. Presentation Layer (`custom_banner_carousel_section.dart`)

#### **CustomBannerCarouselSection**
- Uses `BlocBuilder<BannersCubit, BannersState>` to listen to state changes
- Handles 4 states:
  1. **Loading**: Shows CircularProgressIndicator
  2. **Error**: Shows error message with retry button
  3. **Empty**: Shows "No banners available" message
  4. **Loaded**: Shows carousel with banners

**Features:**
- Auto-play carousel (3 seconds interval)
- Dot indicators
- Navigation to article details on tap
- Smooth animations

### 4. Integration (`home_view.dart`)

```dart
BlocProvider(
  create: (context) => BannersCubit(BannerRepoImpl())..fetchBanners(),
  child: Scaffold(...)
)
```

## How to Replace with Real API

When the backend is ready, update `BannerRepoImpl.fetchBanners()`:

```dart
@override
Future<Either<String, List<ArticleItemModel>>> fetchBanners() async {
  try {
    // Replace this with actual API call
    final response = await _apiService.get('/banners');
    
    final List<ArticleItemModel> banners = (response.data as List)
        .map((json) => ArticleItemModel.fromJson(json))
        .toList();
    
    return Right(banners);
  } catch (e) {
    return Left('Failed to fetch banners: ${e.toString()}');
  }
}
```

## State Management Flow

1. **Initial Load:**
   - `HomeView` creates `BannersCubit`
   - Immediately calls `fetchBanners()`
   - Emits `BannersLoading`
   - Waits 1 second (simulated API delay)
   - Emits `BannersLoaded` with data

2. **Error Handling:**
   - If exception occurs, emits `BannersError`
   - User can tap "Retry" button
   - Calls `refreshBanners()` which re-fetches data

3. **UI Updates:**
   - `BlocBuilder` automatically rebuilds on state changes
   - Shows appropriate UI based on current state

## Benefits of This Architecture

✅ **Separation of Concerns**: Data, logic, and UI are separated
✅ **Testable**: Each layer can be tested independently
✅ **Scalable**: Easy to add more features (e.g., caching, pagination)
✅ **Type-Safe**: Uses Either for error handling
✅ **Future-Proof**: Ready for API integration with minimal changes

## Sample Banners Data

The implementation includes 5 diverse banners:
1. **Economics** - Economic Summit news
2. **Technology** - AI in Healthcare
3. **Environment** - Climate Action Initiative
4. **Education** - Digital Learning Platform
5. **Sports** - Championship Finals

Each banner includes:
- Unique ID
- High-quality image URL (Unsplash)
- Title and description
- Publication date
- Viewer count

---

**Created:** October 18, 2025
**Status:** Ready for Integration
**Next Step:** Replace simulated API with real backend calls
