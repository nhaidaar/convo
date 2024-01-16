import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/models/message_model.dart';
import 'package:convo/models/chatroom_model.dart';
import 'package:convo/models/grouproom_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

class ChatService {
  final _user = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<ChatRoomModel> makeChatRoom({
    required String myUid,
    required String friendUid,
  }) async {
    String roomId = '';

    try {
      await _firestore.collection('chats').add({
        'members': [myUid, friendUid],
      }).then((value) {
        roomId = value.id;
      });

      await _firestore.collection('chats').doc(roomId).set({
        'roomId': roomId,
      }, SetOptions(merge: true));

      return ChatRoomModel(
        roomId: roomId,
        members: [friendUid],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<GroupRoomModel> makeGroupRoom(
      GroupRoomModel groupRoom, File image) async {
    String roomId = '';

    try {
      await _firestore
          .collection('chats')
          .add(groupRoom.toMap())
          .then((value) async {
        // Get the roomId
        roomId = value.id;

        // Set the roomId
        await _firestore.collection('chats').doc(roomId).set({
          'roomId': value.id,
        }, SetOptions(merge: true));
      });

      final groupPicture = await uploadGroupPicture(name: roomId, image: image);

      groupRoom.members!.remove(groupRoom.members![0]);

      await _firestore.collection('chats').doc(roomId).set({
        'groupPicture': groupPicture,
      }, SetOptions(merge: true));

      return GroupRoomModel(
        roomId: roomId,
        members: groupRoom.members,
        title: groupRoom.title,
        groupPicture: groupPicture,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadGroupPicture({
    required String name,
    required File image,
  }) async {
    final storageRef = _storage.ref().child('group/profile_picture/$name.jpg');
    final uploadTask = storageRef.putFile(image);

    final snapshot = await uploadTask;
    final downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<String> uploadChatImage({
    required String uid,
    required String name,
    required File image,
  }) async {
    final storageRef =
        _storage.ref().child('user/image_sent/$uid/Convo_$name.jpg');
    final uploadTask = storageRef.putFile(image);

    final snapshot = await uploadTask;
    final downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<String> sendMessage({
    required String roomId,
    required MessageModel model,
  }) async {
    try {
      await _firestore
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .doc(model.sendAt)
          .set(model.toMap());
      return model.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUnread(MessageModel model) async {
    DocumentReference doc = _firestore
        .collection('chats')
        .doc(model.roomId)
        .collection('messages')
        .doc(model.sendAt);
    DocumentSnapshot docSnapshot = await doc.get();

    MessageModel docModel =
        MessageModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
    List<String> readBy = docModel.readBy;
    List<String> readAt = docModel.readAt;

    readBy.add(_user!.uid);
    readAt.add(DateTime.now().millisecondsSinceEpoch.toString());

    await doc.update(
      {
        'readBy': readBy,
        'readAt': readAt,
      },
    );
  }

  Future<void> deleteMessageForEveryone(MessageModel model) async {
    await _firestore
        .collection('chats')
        .doc(model.roomId)
        .collection('messages')
        .doc(model.sendAt)
        .delete();

    if (model.image.isNotEmpty) {
      await _storage.refFromURL(model.image).delete();
    }
  }

  Future<void> deleteMessageForMe(MessageModel model) async {
    DocumentReference doc = _firestore
        .collection('chats')
        .doc(model.roomId)
        .collection('messages')
        .doc(model.sendAt);
    DocumentSnapshot docSnapshot = await doc.get();

    MessageModel docModel =
        MessageModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
    List<String> hiddenFor = docModel.hiddenFor;

    hiddenFor.add(_user!.uid);

    await doc.update({
      'hiddenFor': hiddenFor,
    });
  }

  Future<void> sendPushNotification({
    required List<String> pushTokens,
    required String from,
    required String msg,
  }) async {
    for (String pushToken in pushTokens) {
      try {
        const fcmApi =
            'AAAAgliY-r8:APA91bGK8DTf7Krhocz_qoMFG7pj5vEgz5S8wAx43n4Cfh3a8Nq_k7cS6_71ED7m9veaspmJJXSyIQynKWoPFIcnAbVcrvXieV5rSv1HWKu8el4KItM7zNUnpVxxp4tVzcFk6Pz-7hbv';
        final body = {
          "to": pushToken,
          "notification": {
            "title": from,
            "body": msg,
            "android_channel_id": "chats"
          },
        };

        await post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'key=$fcmApi'
          },
          body: jsonEncode(body),
        );
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<ChatRoomModel?> isChatRoomExists({
    required String myUid,
    required String friendUid,
  }) async {
    try {
      QuerySnapshot myChatList = await _firestore
          .collection('chats')
          .where('members', arrayContainsAny: [myUid, friendUid]).get();

      for (QueryDocumentSnapshot doc in myChatList.docs) {
        final data = ChatRoomModel.fromMap(doc.data() as Map<String, dynamic>);

        if (data.members!.length == 2 &&
            data.members!.contains(myUid) &&
            data.members!.contains(friendUid)) {
          data.members!.remove(myUid);
          return ChatRoomModel(
            roomId: data.roomId,
            members: data.members,
          );
        }
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<ChatRoomModel>> streamChatList() {
    return _firestore
        .collection('chats')
        .where('members', arrayContains: _user!.uid)
        .snapshots()
        .asyncMap((chatRoomSnapshot) async {
      List<ChatRoomModel> chatRooms = [];

      for (QueryDocumentSnapshot doc in chatRoomSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        if (data['title'] == null) {
          final room = ChatRoomModel.fromMap(data);
          List<String> members = List<String>.from(room.members!);
          members.remove(_user!.uid);

          ChatRoomModel chatRoom = ChatRoomModel(
            roomId: room.roomId,
            members: members,
          );

          chatRooms.add(chatRoom);
        }
      }
      return chatRooms;
    });
  }

  Stream<List<GroupRoomModel>> streamGroupList() {
    return _firestore
        .collection('chats')
        .where('members', arrayContains: _user!.uid)
        .snapshots()
        .asyncMap((chatRoomSnapshot) async {
      List<GroupRoomModel> groupRooms = [];

      for (QueryDocumentSnapshot doc in chatRoomSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        if (data['title'] != null) {
          final room = GroupRoomModel.fromMap(data);
          List<String> members = List<String>.from(room.members!);
          members.remove(_user!.uid);

          GroupRoomModel groupRoom = GroupRoomModel(
            roomId: room.roomId,
            members: members,
            title: room.title,
            groupPicture: room.groupPicture,
          );

          groupRooms.add(groupRoom);
        }
      }
      return groupRooms;
    });
  }

  Stream<List<MessageModel>> streamChat(String roomId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy('sendAt')
        .snapshots()
        .map((querySnapshot) {
      // return querySnapshot.docs.map(
      //   (doc) {
      //     return MessageModel.fromMap(doc.data());
      //   },
      // ).toList();

      List<MessageModel> chatList = querySnapshot.docs
          .map((doc) {
            MessageModel messageModel = MessageModel.fromMap(doc.data());

            // Filter messages that not deleted for me
            if (!messageModel.hiddenFor.contains(_user!.uid)) {
              return messageModel;
            } else {
              return null;
            }
          })
          .whereType<MessageModel>() // Filter out null values
          .toList();

      return chatList;
    });
  }

  Stream<MessageModel> streamLastMessage(String roomId) {
    return _firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy('sendAt', descending: true)
        .snapshots()
        .map((snapshot) {
      // final lastMessageDoc = snapshot.docs.first.data();
      // return MessageModel.fromMap(lastMessageDoc);

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        final msg = MessageModel.fromMap(doc.data() as Map<String, dynamic>);

        if (!msg.hiddenFor.contains(_user!.uid)) {
          return msg;
        }
      }

      return MessageModel(
        roomId: roomId,
        image: '',
        message: '',
        sendBy: '',
        sendAt: '',
        readBy: [],
        readAt: [],
        hiddenFor: [],
      );
    });
  }

  Stream<int> streamUnreadMessage(String roomId) {
    return _firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .snapshots()
        .map((snapshot) {
      int unreadCount = 0;

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        final msg = MessageModel.fromMap(doc.data() as Map<String, dynamic>);

        if (msg.sendBy != _user!.uid && !msg.readBy.contains(_user!.uid)) {
          unreadCount++;
        }
      }

      return unreadCount;
    });
  }
}
