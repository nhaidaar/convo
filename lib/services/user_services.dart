import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  final _firestore = FirebaseFirestore.instance;

  Future<bool> doesUserDataExists(String uid) async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
      final userDocSnapshot = await userDoc.get();
      return userDocSnapshot.exists;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot userData =
          await _firestore.collection('users').doc(uid).get();
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
    final storageRef =
        FirebaseStorage.instance.ref().child('user/profile_picture/$uid.jpg');

    // Upload the file to Firebase Storage
    final uploadTask = storageRef.putFile(image);

    // Get the download URL
    final snapshot = await uploadTask;
    final downloadURL = await snapshot.ref.getDownloadURL();

    // Return the download URL
    return downloadURL;
  }

  Future<void> postUserData(UserModel user) async {
    final CollectionReference userData = _firestore.collection('users');

    try {
      await userData.doc(user.uid).set(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> searchUser(
      {required String search, required String exceptUid}) async {
    final CollectionReference userData = _firestore.collection('users');
    try {
      QuerySnapshot userSnapshot = await userData
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
}
