import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/features/details_artical/data/models/comment_model.dart';
import 'package:sahifa/features/details_artical/ui/widgets/add_comment_widget.dart';
import 'package:sahifa/features/details_artical/ui/widgets/comment_item.dart';
import 'package:sahifa/features/details_artical/ui/widgets/comments_empty_list.dart';
import 'package:sahifa/features/details_artical/ui/widgets/comments_header_section.dart';
import 'package:sahifa/features/details_artical/ui/widgets/show_more_button.dart';

class CommentsSection extends StatefulWidget {
  const CommentsSection({super.key});

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  static const int _initialCommentsToShow = 2;
  bool _showAllComments = false;

  // Sample comments - في المستقبل من الـ backend
  final List<CommentModel> _comments = [
    CommentModel(
      id: '1',
      userName: 'Mohamed Ahmed',
      userAvatar: '',
      comment:
          "This is a great article, very informative and well-written. Thanks for sharing!",
      date: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 12,
    ),
    CommentModel(
      id: '2',
      userName: 'Fatima Ali',
      userAvatar: '',
      comment: 'Valuable information, I hope for more of these topics',
      date: DateTime.now().subtract(const Duration(hours: 5)),
      likes: 8,
    ),
    CommentModel(
      id: '3',
      userName: 'Mohamed Hassan',
      userAvatar: '',
      comment: 'Great article, keep up the good work!',
      date: DateTime.now().subtract(const Duration(days: 1)),
      likes: 5,
    ),
    CommentModel(
      id: '4',
      userName: 'Sarah Ibrahim',
      userAvatar: '',
      comment: 'Very interesting topic, looking forward to more articles',
      date: DateTime.now().subtract(const Duration(days: 2)),
      likes: 3,
    ),
    CommentModel(
      id: '5',
      userName: 'Ahmed Khalil',
      userAvatar: '',
      comment: 'Excellent analysis and well researched content',
      date: DateTime.now().subtract(const Duration(days: 3)),
      likes: 7,
    ),
  ];

  int get _displayedCommentsCount => _showAllComments
      ? _comments.length
      : (_comments.length > _initialCommentsToShow
            ? _initialCommentsToShow
            : _comments.length);

  int get _remainingCommentsCount => _comments.length - _initialCommentsToShow;

  bool get _hasMoreComments => _comments.length > _initialCommentsToShow;

  void _toggleShowAllComments() {
    setState(() {
      _showAllComments = !_showAllComments;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommentsHeaderSection(isDarkMode: isDarkMode, comments: _comments),
          const SizedBox(height: 20),

          FadeInUp(child: const AddCommentWidget()),
          const SizedBox(height: 24),

          if (_comments.isEmpty)
            const CommentsEmptyList()
          else
            _buildCommentsList(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildCommentsList(bool isDarkMode) {
    return Column(
      children: [
        _buildCommentsListView(),

        if (_hasMoreComments && !_showAllComments)
          _buildShowMoreButton(isDarkMode),

        if (_showAllComments && _hasMoreComments)
          _buildShowLessButton(isDarkMode),
      ],
    );
  }

  Widget _buildCommentsListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _displayedCommentsCount,
      itemBuilder: (context, index) {
        return FadeInUp(
          duration: Duration(milliseconds: 300 + (index * 100)),
          child: CommentItem(comment: _comments[index]),
        );
      },
    );
  }

  Widget _buildShowMoreButton(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: FadeInUp(
        child: ShowMoreButton(
          isDarkMode: isDarkMode,
          text: 'Show more ($_remainingCommentsCount)',
          icon: Icons.keyboard_arrow_down_rounded,
          onTap: _toggleShowAllComments,
        ),
      ),
    );
  }

  Widget _buildShowLessButton(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: FadeInUp(
        child: ShowMoreButton(
          isDarkMode: isDarkMode,
          text: 'Show less',
          icon: Icons.keyboard_arrow_up_rounded,
          onTap: _toggleShowAllComments,
        ),
      ),
    );
  }
}
