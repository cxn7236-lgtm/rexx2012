class CommentModel {
  final String commentId;
  final String videoId;
  final String uid;
  final String username;
  final String text;
  final DateTime createdAt;

  CommentModel({
    required this.commentId,
    required this.videoId,
    required this.uid,
    required this.username,
    required this.text,
    required this.createdAt,
  });

  // تحويل من JSON (من Firestore)
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['commentId'] ?? '',
      videoId: json['videoId'] ?? '',
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
      text: json['text'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  // تحويل إلى JSON (حفظ في Firestore)
  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'videoId': videoId,
      'uid': uid,
      'username': username,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
