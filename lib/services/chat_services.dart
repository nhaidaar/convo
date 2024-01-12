import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/models/message_model.dart';
import 'package:convo/models/chatroom_model.dart';
import 'package:convo/models/grouproom_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

class ChatService {
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

      final groupPicture =
          await uploadImageToStorage(name: roomId, image: image);

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

  Future<String> uploadImageToStorage({
    required String name,
    required File image,
  }) async {
    final storageRef = _storage.ref().child('group/profile_picture/$name.jpg');
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
          .add(model.toMap());
      return model.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendPushNotification({
    required List<String> pushTokens,
    required String from,
    required String msg,
  }) async {
    for (String pushToken in pushTokens) {
      try {
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
            HttpHeaders.authorizationHeader:
                'key=AAAAgliY-r8:APA91bGK8DTf7Krhocz_qoMFG7pj5vEgz5S8wAx43n4Cfh3a8Nq_k7cS6_71ED7m9veaspmJJXSyIQynKWoPFIcnAbVcrvXieV5rSv1HWKu8el4KItM7zNUnpVxxp4tVzcFk6Pz-7hbv'
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

  Stream<List<ChatRoomModel>> streamChatList(String uid) {
    return _firestore
        .collection('chats')
        .where('members', arrayContains: uid)
        .snapshots()
        .asyncMap((chatRoomSnapshot) async {
      List<ChatRoomModel> chatRooms = [];

      for (QueryDocumentSnapshot doc in chatRoomSnapshot.docs) {
        final data = ChatRoomModel.fromMap(doc.data() as Map<String, dynamic>);

        if (data.members!.length == 2) {
          List<String> members = List<String>.from(data.members!);
          members.remove(uid);

          ChatRoomModel chatRoom = ChatRoomModel(
            roomId: data.roomId,
            members: members,
          );

          chatRooms.add(chatRoom);
        }
      }

      return chatRooms;
    });
  }

  Stream<List<GroupRoomModel>> streamGroupList(String uid) {
    return _firestore
        .collection('chats')
        .where('members', arrayContains: uid)
        .snapshots()
        .asyncMap((chatRoomSnapshot) async {
      List<GroupRoomModel> groupRooms = [];

      for (QueryDocumentSnapshot doc in chatRoomSnapshot.docs) {
        final data = GroupRoomModel.fromMap(doc.data() as Map<String, dynamic>);

        if (data.members!.length > 2) {
          List<String> members = List<String>.from(data.members!);
          members.remove(uid);

          GroupRoomModel groupRoom = GroupRoomModel(
            roomId: data.roomId,
            members: members,
            title: data.title,
            groupPicture: data.groupPicture,
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
      return querySnapshot.docs.map(
        (doc) {
          return MessageModel.fromMap(doc.data());
        },
      ).toList();
    });
  }

  Stream<MessageModel> streamLastMessage(String roomId) {
    return _firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy('sendAt')
        .snapshots()
        .map((snapshot) {
      final lastMessageDoc = snapshot.docs.last.data();
      return MessageModel.fromMap(lastMessageDoc);
    });
  }
}
