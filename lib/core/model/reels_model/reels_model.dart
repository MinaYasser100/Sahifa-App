import 'reel.dart';

class ReelsModel {
  final List<Reel> reels;
  final String? nextCursor;
  final bool hasMore;

  const ReelsModel({
    required this.reels,
    this.nextCursor,
    required this.hasMore,
  });

  factory ReelsModel.fromJson(Map<String, dynamic> json) => ReelsModel(
    reels:
        (json['reels'] as List<dynamic>?)
            ?.map((e) => Reel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    nextCursor: json['nextCursor'] as String?,
    hasMore: json['hasMore'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'reels': reels.map((e) => e.toJson()).toList(),
    'nextCursor': nextCursor,
    'hasMore': hasMore,
  };

  ReelsModel copyWith({List<Reel>? reels, String? nextCursor, bool? hasMore}) {
    return ReelsModel(
      reels: reels ?? this.reels,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
