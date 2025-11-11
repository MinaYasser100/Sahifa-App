import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/like_post/manager/like_post_cubit/like_post_cubit.dart';
import 'package:sahifa/core/like_post/repo/like_post_repo.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/model/galleries_model/galleries_model.dart';
import 'package:sahifa/core/utils/auth_checker.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/utils/show_top_toast.dart';
import 'package:easy_localization/easy_localization.dart';

class LikeButtonWidget extends StatefulWidget {
  const LikeButtonWidget({
    super.key,
    this.article,
    this.gallery,
    this.size = 20,
    this.radius = 16,
  }) : assert(
          article != null || gallery != null,
          'Either article or gallery must be provided',
        );

  final ArticleModel? article;
  final GalleriesModel? gallery;
  final double size;
  final double radius;

  @override
  State<LikeButtonWidget> createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget> {
  late bool _isLiked;
  late int _likesCount;
  late String _postId;

  @override
  void initState() {
    super.initState();
    
    // Get data from either article or gallery
    if (widget.article != null) {
      _isLiked = widget.article!.isLikedByCurrentUser ?? false;
      _likesCount = widget.article!.likesCount ?? 0;
      _postId = widget.article!.id!;
    } else if (widget.gallery != null) {
      _isLiked = widget.gallery!.isLikedByCurrentUser ?? false;
      _likesCount = widget.gallery!.likesCount ?? 0;
      _postId = widget.gallery!.id!;
    }
  }

  Future<void> _handleLikeTap(BuildContext context) async {
    // Check authentication first
    if (!await AuthChecker.checkAuthAndNavigate(context)) {
      return; // User not authenticated, redirected to login
    }

    // User is authenticated, proceed with like
    if (!mounted) return;

    context.read<LikePostCubit>().toggleLike(_postId, _isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LikePostCubit(LikePostRepoImpl(DioHelper())),
      child: BlocConsumer<LikePostCubit, LikePostState>(
        listener: (context, state) {
          if (state is LikePostSuccess && state.postId == _postId) {
            // Update UI optimistically
            setState(() {
              _isLiked = state.isLiked;
              _likesCount = state.isLiked ? _likesCount + 1 : _likesCount - 1;
            });
          } else if (state is LikePostError && state.postId == _postId) {
            // Show error toast
            _handleError(context, state);
          }
        },
        builder: (context, state) {
          final isLoading = state is LikePostLoading && state.postId == _postId;

          return GestureDetector(
            onTap: isLoading ? null : () => _handleLikeTap(context),
            child: FadeInDown(
              child: CircleAvatar(
                radius: widget.radius,
                backgroundColor: ColorsTheme().whiteColor,
                child: isLoading
                    ? SizedBox(
                        width: widget.size,
                        height: widget.size,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ColorsTheme().primaryColor,
                        ),
                      )
                    : Icon(
                        _isLiked
                            ? FontAwesomeIcons.solidHeart
                            : FontAwesomeIcons.heart,
                        color: _isLiked
                            ? ColorsTheme().errorColor
                            : ColorsTheme().primaryColor,
                        size: widget.size,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleError(BuildContext context, LikePostError state) {
    // Parse error message to show appropriate message
    String errorTitle = 'error'.tr();
    String errorMessage = state.message;

    // Handle specific error cases based on HTTP status codes and error messages
    if (state.message.contains('401') ||
        state.message.contains('Unauthorized')) {
      errorMessage = 'unauthorized_action'.tr();
    } else if (state.message.contains('404') ||
        state.message.contains('Not Found')) {
      errorMessage = 'post_not_found'.tr();
    } else if (state.message.contains('409') ||
        state.message.contains('Conflict')) {
      errorMessage = 'action_already_performed'.tr();
    } else if (state.message.contains('422') ||
        state.message.contains('Unprocessable') ||
        state.message.contains('400') ||
        state.message.contains('Bad Request')) {
      errorMessage = 'validation_error'.tr();
    } else {
      errorMessage = 'failed_to_like_post'.tr();
    }

    showErrorToast(context, errorTitle, errorMessage);
  }
}
