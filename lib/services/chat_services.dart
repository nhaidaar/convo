import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/models/chat_model.dart';
import 'package:convo/models/chatroom_model.dart';
import 'package:convo/models/user_model.dart';
import 'package:convo/services/user_services.dart';

class ChatService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<ChatRoomModel>> getAllPersonalChats(String uid) async {
    List<ChatRoomModel> chatRooms = [];

    try {
      QuerySnapshot chatRoomSnapshot = await _firestore
          .collection('chats')
          .where('members', arrayContains: uid)
          .get();

      for (QueryDocumentSnapshot doc in chatRoomSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        List<String> members = List<String>.from(data['members']);
        members.remove(uid);

        QuerySnapshot messageSnapshot =
            await doc.reference.collection('messages').orderBy('sendAt').get();

        ChatModel lastMessage = ChatModel.fromMap(
            messageSnapshot.docs.last.data() as Map<String, dynamic>);

        UserModel? interlocutor = await UserService().getUserData(members[0]);

        ChatRoomModel chatRoom = ChatRoomModel(
          roomId: data['roomId'],
          members: members,
          lastMessage: lastMessage,
          interlocutor: interlocutor,
        );

        chatRooms.add(chatRoom);
      }
    } catch (e) {
      rethrow;
    }
    return chatRooms;
  }

  Future<List<ChatModel>> getAllMessages(String roomId) async {
    try {
      QuerySnapshot chatSnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .orderBy('sendAt')
          .get();

      List<ChatModel> messages = [];

      if (chatSnapshot.docs.isNotEmpty) {
        messages = chatSnapshot.docs.map(
          (doc) {
            return ChatModel.fromMap(doc.data() as Map<String, dynamic>);
          },
        ).toList();
      }

      return messages;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendMessage(String roomId, ChatModel model) async {
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
}
