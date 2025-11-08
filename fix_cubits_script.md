# Script to Fix All Cubits - Add isClosed Checks

## Pattern to Add:

### Before any async method:
```dart
Future<void> fetchData() async {
  if (isClosed) return;  // ✅ Add this
  
  emit(Loading());
  final result = await repo.getData();
  
  if (isClosed) return;  // ✅ Add this after async call
  
  result.fold(
    (error) {
      if (!isClosed) emit(Error(error));  // ✅ Add check in fold
    },
    (data) {
      if (!isClosed) emit(Loaded(data));  // ✅ Add check in fold
    },
  );
}
```

## Cubits Already Fixed:
1. ✅ DetailsArticleCubit
2. ✅ TrendingCubit
3. ✅ AudioCategoriesCubit
4. ✅ AudioByCategoryCubit
5. ✅ ArticlesBreakingNewsCubit (already had checks)

## Cubits to Fix:
- ArticlesHomeCategoryCubit
- DrawerCategoriesCubit
- CategoriesHorizontalBarCubit
- ArticlesParentCategoryCubit
- ArticlesHorizontalBarCategoryCubit
- ArticlesDrawerSubcategoryCubit
- AllCategoryArticlesCubit
- SubcategoryArticlesCubit
- HorizontalBarSubcategoriesCubit
- SearchCategoriesCubit
- SearchArticlesCubit
- ArticlesSearchCategoryCubit
- MyFavoriteCubit
- TvCubit
- PdfCubit
- MagazinesCubit
- ReelsCubit
- AuthCubit
- LoginCubit

## Quick Fix Template:

```dart
// At start of async method
if (isClosed) return;

// After await
if (isClosed) return;

// In fold/then
if (!isClosed) emit(state);
```
