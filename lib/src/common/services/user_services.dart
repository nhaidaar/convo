import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/src/common/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  final _firestore = FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser;

  Stream<UserModel> streamUserData(String uid) {
    return _firestore.doc(uid).snapshots().map((user) {
      return UserModel.fromMap(user.data()!);
    });
  }

  Future<UserModel?> getSelfData() async {
    try {
      DocumentSnapshot userData = await _firestore.doc(user!.uid).get();
      UserModel userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);
      return userModel;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot userData = await _firestore.doc(uid).get();
      UserModel userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);
      return userModel;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> getUserToken(List<String> uids) async {
    List<String> tokens = [];
    for (String uid in uids) {
      DocumentSnapshot userData = await _firestore.doc(uid).get();
      UserModel userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);
      String token = userModel.pushToken.toString();
      tokens.add(token);
    }
    return tokens;
  }

  Future<String?> getFCMToken() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    return await fcm.getToken();
  }

  Future<String> uploadImageToStorage({
    required String uid,
    required File image,
  }) async {
    final storageRef = FirebaseStorage.instance.ref().child(
          'user/profile_picture/$uid.jpg',
        );
    final uploadTask = storageRef.putFile(image);

    final snapshot = await uploadTask;
    final downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> postUserData(UserModel user) async {
    try {
      await _firestore.doc(user.uid).set(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> searchUser({
    required String search,
    required String exceptUid,
  }) async {
    try {
      QuerySnapshot userSnapshot =
          await _firestore.where('username', isEqualTo: search).where('uid', isNotEqualTo: exceptUid).get();

      List<UserModel> users = [];

      if (userSnapshot.docs.isNotEmpty) {
        users = userSnapshot.docs.map((doc) {
          return UserModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      }
      return users;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkUsername(String username) async {
    try {
      QuerySnapshot userSnapshot = await _firestore.where('username', isEqualTo: username).get();

      if (userSnapshot.docs.isNotEmpty) {
        return true; // Username taken
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateOnlineStatus(bool isOnline) async {
    final token = await getFCMToken();
    await _firestore.doc(user!.uid).update({
      'isOnline': isOnline,
      'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
      'pushToken': token,
    });
  }

  Future<void> updateUserData(UserModel userModel) async {
    await _firestore.doc(userModel.uid).set(userModel.toMap());
  }
}
