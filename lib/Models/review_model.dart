class ReviewModel {
  final String id;
  final int rating;
  final String comment;
  final String createdAt;
  final String reviewerName;
  final String reviewerAvatar;

  ReviewModel({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.reviewerName,
    required this.reviewerAvatar,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final attr = json['attributes'] ?? {};
    final reviewerAttr =
        json['relationships']?['reviewer']?['attributes'] ?? {};

    return ReviewModel(
      id: json['id']?.toString() ?? '',
      rating: attr['rating'] ?? 0,
      comment: attr['comment'] ?? '',
      createdAt: attr['created_at'] ?? '',
      reviewerName: reviewerAttr['full_name'] ?? 'Anonymous',
      reviewerAvatar: (reviewerAttr['avatar_url'] ?? '').toString().replaceAll(
        '127.0.0.1:8000',
        '10.0.2.2:8000',
      ),
    );
  }
}
