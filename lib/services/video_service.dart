import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../models/video_model.dart';

class VideoService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _videoBucket = 'videos';
  final String _thumbnailBucket = 'thumbnails';

  // تحميل الفيديو
  Future<VideoModel?> uploadVideo({
    required File videoFile,
    required String title,
    required String description,
    required String uid,
    required String username,
  }) async {
    try {
      final videoId = const Uuid().v4();
      final videoRef = _storage.ref().child('$_videoBucket/$uid/$videoId.mp4');

      // تحميل الفيديو
      await videoRef.putFile(videoFile);
      final videoUrl = await videoRef.getDownloadURL();

      // إنشاء بيانات الفيديو
      VideoModel video = VideoModel(
        videoId: videoId,
        uid: uid,
        username: username,
        title: title,
        description: description,
        videoUrl: videoUrl,
        thumbnailUrl: '', // سيتم إضافة الصورة المصغرة لاحقاً
        createdAt: DateTime.now(),
      );

      // حفظ بيانات الفيديو في Firestore
      await _firestore.collection('videos').doc(videoId).set(video.toJson());

      // إضافة الفيديو لقائمة فيديوهات المستخدم
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('videos')
          .doc(videoId)
          .set({'videoId': videoId, 'createdAt': DateTime.now()});

      return video;
    } catch (e) {
      print('خطأ في تحميل الفيديو: $e');
      return null;
    }
  }

  // جلب جميع الفيديوهات
  Future<List<VideoModel>> getAllVideos() async {
    try {
      final snapshot =
          await _firestore.collection('videos').orderBy('createdAt', descending: true).get();

      return snapshot.docs
          .map((doc) => VideoModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('خطأ في جلب الفيديوهات: $e');
      return [];
    }
  }

  // جلب فيديوهات مستخدم معين
  Future<List<VideoModel>> getUserVideos(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('videos')
          .where('uid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => VideoModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('خطأ في جلب فيديوهات المستخدم: $e');
      return [];
    }
  }

  // البحث عن الفيديوهات
  Future<List<VideoModel>> searchVideos(String query) async {
    try {
      // البحث في العنوان والوصف
      final snapshot = await _firestore.collection('videos').get();

      final results = snapshot.docs
          .map((doc) => VideoModel.fromJson(doc.data()))
          .where((video) =>
              video.title.toLowerCase().contains(query.toLowerCase()) ||
              video.description.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return results;
    } catch (e) {
      print('خطأ في البح��: $e');
      return [];
    }
  }

  // حذف الفيديو
  Future<bool> deleteVideo(String videoId, String uid) async {
    try {
      // حذف الفيديو من Storage
      await _storage.ref('$_videoBucket/$uid/$videoId.mp4').delete();

      // حذف من Firestore
      await _firestore.collection('videos').doc(videoId).delete();

      // حذف من قائمة المستخدم
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('videos')
          .doc(videoId)
          .delete();

      return true;
    } catch (e) {
      print('خطأ في حذف الفيديو: $e');
      return false;
    }
  }

  // زيادة عدد المشاهدات
  Future<void> incrementViews(String videoId) async {
    try {
      await _firestore.collection('videos').doc(videoId).update({
        'views': FieldValue.increment(1),
      });
    } catch (e) {
      print('خطأ في تحديث المشاهدات: $e');
    }
  }

  // الإعجاب بالفيديو
  Future<void> likeVideo(String videoId) async {
    try {
      await _firestore.collection('videos').doc(videoId).update({
        'likes': FieldValue.increment(1),
      });
    } catch (e) {
      print('خطأ في الإعجاب: $e');
    }
  }

  // إلغاء الإعجاب
  Future<void> unlikeVideo(String videoId) async {
    try {
      await _firestore.collection('videos').doc(videoId).update({
        'likes': FieldValue.increment(-1),
      });
    } catch (e) {
      print('خطأ في إلغاء الإعجاب: $e');
    }
  }

  // جلب فيديو واحد
  Future<VideoModel?> getVideoById(String videoId) async {
    try {
      final doc = await _firestore.collection('videos').doc(videoId).get();

      if (doc.exists) {
        return VideoModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('خطأ في جلب الفيديو: $e');
    }
    return null;
  }
}
