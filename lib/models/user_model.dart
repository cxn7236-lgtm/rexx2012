class UserModel {
  final String uid;
  final String email;
  final String username;
  final String profileImageUrl;
  final String bio;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.profileImageUrl = '',
    this.bio = '',
    required this.createdAt,
  });

  // تحويل من JSON (من Firestore)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      bio: json['bio'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  // تحويل إلى JSON (حفظ في Firestore)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
