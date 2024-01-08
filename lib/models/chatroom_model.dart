import 'package:convo/models/chat_model.dart';
import 'package:convo/models/user_model.dart';

class ChatRoomModel {
  final String? roomId;
  final List<String>? members;
  final ChatModel? lastMessage;
  final UserModel? interlocutor;

  ChatRoomModel({
    this.roomId,
    this.members,
    this.lastMessage,
    this.interlocutor,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'members': members,
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      roomId: map['roomId'],
      members: List<String>.from(map['members']),
    );
  }
}
