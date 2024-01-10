import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/models/chat_model.dart';
import 'package:convo/models/chatroom_model.dart';
import 'package:convo/models/user_model.dart';
import 'package:convo/services/user_services.dart';

class ChatService {
  final _firestore = FirebaseFirestore.instance;

  Future<ChatRoomModel> makeChatRoom({
    required String myUid,
    required String interlocutorUid,
    // required ChatModel chat,
  }) async {
    String roomId = '';

    try {
      await _firestore.collection('chats').add({
        'members': [
          myUid,
          interlocutorUid,
        ],
      }).then((value) {
        roomId = value.id;
      });

      await _firestore.collection('chats').doc(roomId).set({
        'roomId': roomId,
      }, SetOptions(merge: true));

      // await sendMessage(roomId: roomId, model: chat);

      UserModel? interlocutor =
          await UserService().getUserData(interlocutorUid);

      return ChatRoomModel(
        roomId: roomId,
        members: [
          myUid,
          interlocutorUid,
        ],
        interlocutor: interlocutor,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendMessage({
    required String roomId,
    required ChatModel model,
  }) async {
    try {
      await _firestore
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .add(model.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<ChatRoomModel?> isChatRoomExists({
    required String myUid,
    required String interlocutorUid,
  }) async {
    try {
      QuerySnapshot myChatList = await _firestore
          .collection('chats')
          .where('members', arrayContainsAny: [myUid, interlocutorUid])
          .limit(1)
          .get();

      for (QueryDocumentSnapshot doc in myChatList.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<String> members = List<String>.from(data['members']);
        UserModel? interlocutor =
            await UserService().getUserData(interlocutorUid);

        if (members.length == 2 &&
            members.contains(myUid) &&
            members.contains(interlocutorUid)) {
          return ChatRoomModel(
            roomId: data['roomId'],
            members: members,
            interlocutor: interlocutor,
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
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        List<String> members = List<String>.from(data['members']);
        members.remove(uid);

        UserModel? interlocutor = await UserService().getUserData(members[0]);

        ChatRoomModel chatRoom = ChatRoomModel(
          roomId: data['roomId'],
          members: members,
          interlocutor: interlocutor,
        );

        chatRooms.add(chatRoom);
      }

      return chatRooms;
    });
  }

  Stream<List<ChatModel>> streamChat(String roomId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy('sendAt')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map(
        (doc) {
          return ChatModel.fromMap(doc.data());
        },
      ).toList();
    });
  }

  Stream<ChatModel> streamLastMessage(String roomId) {
    return _firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy('sendAt')
        .snapshots()
        .map((snapshot) {
      final lastMessageDoc = snapshot.docs.last.data();
      return ChatModel.fromMap(lastMessageDoc);
    });
  }
}
