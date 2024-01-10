part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class GetChatListEvent extends ChatEvent {
  final String uid;
  const GetChatListEvent(this.uid);

  @override
  List<Object> get props => [uid];
}

class GetGroupListEvent extends ChatEvent {
  final String uid;
  const GetGroupListEvent(this.uid);

  @override
  List<Object> get props => [uid];
}

class GetAllMessageEvent extends ChatEvent {
  final String roomId;
  const GetAllMessageEvent(this.roomId);

  @override
  List<Object> get props => [roomId];
}

class GetLastMessageEvent extends ChatEvent {
  final String roomId;
  const GetLastMessageEvent(this.roomId);

  @override
  List<Object> get props => [roomId];
}

class SendMessageEvent extends ChatEvent {
  final String roomId;
  final ChatModel message;
  const SendMessageEvent({
    required this.roomId,
    required this.message,
  });

  @override
  List<Object> get props => [roomId, message];
}

class MakeChatRoomEvent extends ChatEvent {
  final String myUid;
  final String interlocutorUid;
  const MakeChatRoomEvent({
    required this.myUid,
    required this.interlocutorUid,
  });

  @override
  List<Object> get props => [myUid, interlocutorUid];
}

class MakeGroupRoomEvent extends ChatEvent {
  final List<UserModel> members;
  const MakeGroupRoomEvent(this.members);

  @override
  List<Object> get props => [members];
}
