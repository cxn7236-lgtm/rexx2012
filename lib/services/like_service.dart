import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class LikeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // التحقق من إعجاب المستخدم
  Future<bool> isLiked(String videoId, String uid) async {
    try {
      final doc = await _firestore
          .collection('videos')
          .doc(videoId)
          .collection('likes')
          .doc(uid)
          .get();

      return doc.exists;
    } catch (e) {
      print('خطأ في التحقق من الإعجاب: $e');
      return false;
    }
  }

  // إضافة إعجاب
  Future<bool> likeVideo(String videoId, String uid) async {
    try {
      await _firestore
          .collection('videos')
          .doc(videoId)
          .collection('likes')
          .doc(uid)
          .set({
        'uid': uid,
        'createdAt': DateTime.now(),
      });

      // زيادة عدد الإعجابات
      await _firestore.collection('videos').doc(videoId).update({
        'likes': FieldValue.increment(1),
      });

      return true;
    } catch (e) {
      print('خطأ في الإعجاب: $e');
      return false;
    }
  }

  // إلغاء الإعجاب
  Future<bool> unlikeVideo(String videoId, String uid) async {
    try {
      await _firestore
          .collection('videos')
          .doc(videoId)
          .collection('likes')
          .doc(uid)
          .delete();

      // تقليل عدد الإعجابات
      await _firestore.collection('videos').doc(videoId).update({
        'likes': FieldValue.increment(-1),
      });

      return true;
    } catch (e) {
      print('خطأ في إلغاء الإعجاب: $e');
      return false;
    }
  }

  // جلب عدد الإعجابات
  Future<int> getLikesCount(String videoId) async {
    try {
      final snapshot = await _firestore
          .collection('videos')
          .doc(videoId)
          .collection('likes')
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('خطأ في جلب عدد الإعجابات: $e');
      return 0;
    }
  }
}
