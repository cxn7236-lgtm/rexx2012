import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment_model.dart';
import 'package:uuid/uuid.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // إضافة تعليق
  Future<CommentModel?> addComment({
    required String videoId,
    required String uid,
    required String username,
    required String text,
  }) async {
    try {
      final commentId = const Uuid().v4();
      final comment = CommentModel(
        commentId: commentId,
        videoId: videoId,
        uid: uid,
        username: username,
        text: text,
        createdAt: DateTime.now(),
      );

      // حفظ التعليق في Firestore
      await _firestore
          .collection('videos')
          .doc(videoId)
          .collection('comments')
          .doc(commentId)
          .set(comment.toJson());

      // زيادة عدد التعليقات
      await _firestore.collection('videos').doc(videoId).update({
        'comments': FieldValue.increment(1),
      });

      return comment;
    } catch (e) {
      print('خطأ في إضافة التعليق: $e');
      return null;
    }
  }

  // جلب جميع التعليقات
  Future<List<CommentModel>> getComments(String videoId) async {
    try {
      final snapshot = await _firestore
          .collection('videos')
          .doc(videoId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => CommentModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('خطأ في جلب التعليقات: $e');
      return [];
    }
  }

  // حذف تعليق
  Future<bool> deleteComment(String videoId, String commentId) async {
    try {
      await _firestore
          .collection('videos')
          .doc(videoId)
          .collection('comments')
          .doc(commentId)
          .delete();

      // تقليل عدد التعليقات
      await _firestore.collection('videos').doc(videoId).update({
        'comments': FieldValue.increment(-1),
      });

      return true;
    } catch (e) {
      print('خطأ في حذف التعليق: $e');
      return false;
    }
  }

  // Stream التعليقات (للتحديث الفوري)
  Stream<List<CommentModel>> commentsStream(String videoId) {
    return _firestore
        .collection('videos')
        .doc(videoId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CommentModel.fromJson(doc.data()))
            .toList());
  }
}
