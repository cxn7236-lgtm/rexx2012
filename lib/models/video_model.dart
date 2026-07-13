class VideoModel {
  final String videoId;
  final String uid;
  final String username;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final DateTime createdAt;
  final int views;
  final int likes;
  final int comments;

  VideoModel({
    required this.videoId,
    required this.uid,
    required this.username,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.createdAt,
    this.views = 0,
    this.likes = 0,
    this.comments = 0,
  });

  // تحويل من JSON (من Firestore)
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      videoId: json['videoId'] ?? '',
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      views: json['views'] ?? 0,
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
    );
  }

  // تحويل إلى JSON (حفظ في Firestore)
  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'uid': uid,
      'username': username,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': createdAt.toIso8601String(),
      'views': views,
      'likes': likes,
      'comments': comments,
    };
  }
}
