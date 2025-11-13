import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/features/reels/data/repo/reels_api_repo.dart';
import 'package:sahifa/features/reels/manager/reels_cubit/reels_state.dart';

/// Cubit بسيط لإدارة بيانات الـ Reels فقط (بدون video management)
class ReelsCubit extends Cubit<ReelsState> {
  final ReelsApiRepo _reelsRepo;

  ReelsCubit(this._reelsRepo) : super(ReelsInitial());

  // Pagination state
  String? _nextCursor;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  int _currentIndex = 0;

  /// تحميل أول صفحة من الريلز
  Future<void> loadReels({bool forceRefresh = false}) async {
    if (isClosed) return;

    try {
      emit(ReelsLoading());

      if (forceRefresh) {
        await _reelsRepo.clearCache();
        _currentIndex = 0;
      }

      final reelsModel = await _reelsRepo.fetchReels(cursor: null);

      _nextCursor = reelsModel.nextCursor;
      _hasMore = reelsModel.hasMore;

      if (isClosed) return;
      emit(
        ReelsLoaded(
          reels: reelsModel.reels,
          hasMore: _hasMore,
          currentIndex: _currentIndex,
        ),
      );
    } catch (e) {
      if (!isClosed) {
        emit(ReelsError('Error loading reels: $e'));
      }
    }
  }

  /// تحميل المزيد من الريلز (pagination)
  Future<void> loadMoreReels() async {
    if (isClosed || _isLoadingMore || !_hasMore) return;

    final currentState = state;
    if (currentState is! ReelsLoaded) return;

    try {
      _isLoadingMore = true;
      emit(currentState.copyWith(isLoadingMore: true));

      final reelsModel = await _reelsRepo.fetchReels(cursor: _nextCursor);

      _nextCursor = reelsModel.nextCursor;
      _hasMore = reelsModel.hasMore;

      final updatedReels = [...currentState.reels, ...reelsModel.reels];

      if (isClosed) return;
      emit(
        ReelsLoaded(
          reels: updatedReels,
          hasMore: _hasMore,
          currentIndex: currentState.currentIndex,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      if (!isClosed) {
        final loadedState = state;
        if (loadedState is ReelsLoaded) {
          emit(loadedState.copyWith(isLoadingMore: false));
        }
      }
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Refresh (Pull to refresh)
  Future<void> refreshReels() async {
    await loadReels(forceRefresh: true);
  }

  /// تغيير الصفحة الحالية
  void changePage(int index) {
    _currentIndex = index;

    final currentState = state;
    if (currentState is ReelsLoaded) {
      emit(currentState.copyWith(currentIndex: index));

      // لو قربنا من الآخر، حمل المزيد
      if (index >= currentState.reels.length - 3 &&
          _hasMore &&
          !_isLoadingMore) {
        loadMoreReels();
      }
    }
  }

  /// Toggle Like
  Future<void> toggleLike(String reelId) async {
    final currentState = state;
    if (currentState is! ReelsLoaded) return;

    try {
      // Update UI optimistically
      final updatedReels = currentState.reels.map((reel) {
        if (reel.id == reelId) {
          final isLiked = reel.isLikedByCurrentUser ?? false;
          return reel.copyWith(
            isLikedByCurrentUser: !isLiked,
            likesCount: isLiked ? reel.likesCount - 1 : reel.likesCount + 1,
          );
        }
        return reel;
      }).toList();

      emit(currentState.copyWith(reels: updatedReels));

      // Call API
      await _reelsRepo.toggleReelLike(reelId);
    } catch (e) {
      // Revert on error
      emit(currentState);
    }
  }
}
