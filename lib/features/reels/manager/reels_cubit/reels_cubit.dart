import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/features/reels/data/repo/reels_api_repo.dart';
import 'package:sahifa/features/reels/manager/reels_cubit/reels_state.dart';

class ReelsCubit extends Cubit<ReelsState> {
  final ReelsApiRepo _reelsRepo;

  ReelsCubit(this._reelsRepo) : super(ReelsInitial());

  // Pagination state
  String? _nextCursor;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  // حفظ آخر موضع للمستخدم
  int _savedIndex = 0;
  List<String> _lastReelIds = []; // للتحقق من تغيير البيانات

  /// Load initial reels (first page)
  Future<void> loadReels({bool forceRefresh = false}) async {
    if (isClosed) return;

    try {
      emit(ReelsLoading());

      if (forceRefresh) {
        await _reelsRepo.clearCache();
        _savedIndex = 0; // إعادة تعيين عند الـ refresh
      }

      // Fetch first page
      final reelsModel = await _reelsRepo.fetchReels(cursor: null);

      // Update pagination state
      _nextCursor = reelsModel.nextCursor;
      _hasMore = reelsModel.hasMore;

      // التحقق من تغيير البيانات
      final newReelIds = reelsModel.reels.map((r) => r.id).toList();
      final dataChanged = !_areListsEqual(_lastReelIds, newReelIds);

      if (dataChanged) {
        _savedIndex = 0; // البيانات اتغيرت، نبدأ من الأول
      }
      _lastReelIds = newReelIds;

      if (isClosed) return;
      emit(
        ReelsLoaded(
          reels: reelsModel.reels,
          hasMore: _hasMore,
          currentIndex: _savedIndex, // استخدام آخر موضع محفوظ
        ),
      );
    } catch (e) {
      if (!isClosed) {
        emit(ReelsError('Error loading reels: $e'));
      }
    }
  }

  /// مقارنة قوائم الـ IDs للتحقق من تغيير البيانات
  bool _areListsEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  /// Load more reels (pagination)
  Future<void> loadMoreReels() async {
    if (isClosed || _isLoadingMore || !_hasMore) return;

    final currentState = state;
    if (currentState is! ReelsLoaded) return;

    try {
      _isLoadingMore = true;
      emit(currentState.copyWith(isLoadingMore: true));

      // Fetch next page
      final reelsModel = await _reelsRepo.fetchReels(cursor: _nextCursor);

      // Update pagination state
      _nextCursor = reelsModel.nextCursor;
      _hasMore = reelsModel.hasMore;

      // Merge new reels with existing ones
      final updatedReels = [...currentState.reels, ...reelsModel.reels];

      if (isClosed) return;
      emit(
        ReelsLoaded(
          reels: updatedReels,
          hasMore: _hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      if (!isClosed) {
        emit(
          currentState.copyWith(
            isLoadingMore: false,
            error: 'Error loading more reels: $e',
          ),
        );
      }
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Change current page (for PageView)
  void changePage(int index) {
    if (isClosed) return;

    final currentState = state;
    if (currentState is ReelsLoaded) {
      _savedIndex = index; // حفظ آخر موضع
      emit(currentState.copyWith(currentIndex: index));

      // Load more when reaching near the end (e.g., 3 reels before end)
      if (_hasMore && index >= currentState.reels.length - 3) {
        loadMoreReels();
      }
    }
  }

  /// إيقاف كل الفيديوهات عند مغادرة Reels
  void pauseAllVideos() {
    // سيتم استدعاؤها من ReelsBodyView.dispose
  }

  /// Toggle like on a reel (Old method - kept for backward compatibility)
  void toggleLike(String reelId) {
    if (isClosed) return;

    final currentState = state;
    if (currentState is ReelsLoaded) {
      final updatedReels = currentState.reels.map((reel) {
        if (reel.id == reelId) {
          final isLiked = reel.isLikedByCurrentUser ?? false;
          final newLikesCount = isLiked
              ? reel.likesCount - 1
              : reel.likesCount + 1;

          return reel.copyWith(
            isLikedByCurrentUser: !isLiked,
            likesCount: newLikesCount,
          );
        }
        return reel;
      }).toList();

      emit(currentState.copyWith(reels: updatedReels));

      // Call API to toggle like
      _reelsRepo.toggleReelLike(reelId).catchError((error) {
        // Revert on error
        if (!isClosed && state is ReelsLoaded) {
          emit(currentState);
        }
      });
    }
  }

  /// Update reel like state (for use with LikeReelCubit)
  void updateReelLikeState({required String reelId, required bool isLiked}) {
    if (isClosed) return;

    final currentState = state;
    if (currentState is ReelsLoaded) {
      final updatedReels = currentState.reels.map((reel) {
        if (reel.id == reelId) {
          final currentlyLiked = reel.isLikedByCurrentUser ?? false;
          final newLikesCount = isLiked
              ? (currentlyLiked ? reel.likesCount : reel.likesCount + 1)
              : (currentlyLiked ? reel.likesCount - 1 : reel.likesCount);

          return reel.copyWith(
            isLikedByCurrentUser: isLiked,
            likesCount: newLikesCount,
          );
        }
        return reel;
      }).toList();

      emit(currentState.copyWith(reels: updatedReels));
    }
  }

  /// Refresh reels (pull to refresh)
  Future<void> refreshReels() async {
    await loadReels(forceRefresh: true);
  }

  /// Clear cache
  Future<void> clearCache() async {
    await _reelsRepo.clearCache();
  }
}
