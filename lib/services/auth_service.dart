import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // تسجيل مستخدم جديد
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // إنشاء حساب في Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // إنشاء بيانات المستخدم
        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          username: username,
          createdAt: DateTime.now(),
        );

        // حفظ بيانات المستخدم في Firestore
        await _firestore.collection('users').doc(user.uid).set(newUser.toJson());

        return newUser;
      }
    } catch (e) {
      print('خطأ في التسجيل: $e');
    }
    return null;
  }

  // دخول المستخدم
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // جلب بيانات المستخدم من Firestore
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();

        if (doc.exists) {
          return UserModel.fromJson(doc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      print('خطأ في الدخول: $e');
    }
    return null;
  }

  // تسجيل الخروج
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('خطأ في تسجيل الخروج: $e');
    }
  }

  // الحصول على بيانات المستخدم الحالي
  Future<UserModel?> getCurrentUser() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();

        if (doc.exists) {
          return UserModel.fromJson(doc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      print('خطأ في جلب بيانات المستخدم: $e');
    }
    return null;
  }

  // التحقق من تسجيل دخول المستخدم
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  // تحديث ملف المستخدم الشخصي
  Future<bool> updateUserProfile({
    required String uid,
    String? username,
    String? bio,
    String? profileImageUrl,
  }) async {
    try {
      Map<String, dynamic> updates = {};

      if (username != null) updates['username'] = username;
      if (bio != null) updates['bio'] = bio;
      if (profileImageUrl != null) updates['profileImageUrl'] = profileImageUrl;

      await _firestore.collection('users').doc(uid).update(updates);
      return true;
    } catch (e) {
      print('خطأ في تحديث الملف الشخصي: $e');
      return false;
    }
  }

  // جلب بيانات مستخدم معين
  Future<UserModel?> getUserById(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('خطأ في جلب بيانات المستخدم: $e');
    }
    return null;
  }
}
