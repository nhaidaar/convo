import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  final _firestore = FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser;

  Future<bool> isUserExists(String uid) async {
    try {
      final userDocSnapshot = await _firestore.doc(uid).get();
      return userDocSnapshot.exists;
    } catch (e) {
      return false;
    }
  }

  Stream<UserModel> streamUserData(String uid) {
    return _firestore.doc(uid).snapshots().map((user) {
      return UserModel.fromMap(user.data()!);
    });
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot userData = await _firestore.doc(uid).get();
      UserModel userModel =
          UserModel.fromMap(userData.data() as Map<String, dynamic>);
      return userModel;
    } catch (e) {
      return null;
    }
  }

  Future<String> uploadImageToStorage({
    required String uid,
    required File image,
  }) async {
    final storageRef = FirebaseStorage.instance.ref().child(
          'user/profile_picture/$uid.jpg',
        );

    // Upload the file to Firebase Storage
    final uploadTask = storageRef.putFile(image);

    // Get the download URL
    final snapshot = await uploadTask;
    final downloadURL = await snapshot.ref.getDownloadURL();

    // Return the download URL
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
      QuerySnapshot userSnapshot = await _firestore
          .where('username', isEqualTo: search)
          .where('uid', isNotEqualTo: exceptUid)
          .get();

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

  Future<void> updateOnlineStatus(bool isOnline) async {
    await _firestore.doc(user!.uid).update({
      'isOnline': isOnline,
      'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }
}
