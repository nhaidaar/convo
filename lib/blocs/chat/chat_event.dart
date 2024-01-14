part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class GetChatListEvent extends ChatEvent {}

class GetGroupListEvent extends ChatEvent {}

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

class GetUnreadMessageEvent extends ChatEvent {
  final String roomId;
  const GetUnreadMessageEvent(this.roomId);

  @override
  List<Object> get props => [roomId];
}

class SendMessageEvent extends ChatEvent {
  final String roomId;
  final MessageModel message;
  const SendMessageEvent({
    required this.roomId,
    required this.message,
  });

  @override
  List<Object> get props => [roomId, message];
}

class SendNotificationEvent extends ChatEvent {
  final String from;
  final List<String> to;
  final String groupTitle;
  final String message;
  const SendNotificationEvent({
    required this.from,
    required this.to,
    required this.groupTitle,
    required this.message,
  });

  @override
  List<Object> get props => [to, from, groupTitle, message];
}

class MakeChatRoomEvent extends ChatEvent {
  final String myUid;
  final String friendUid;
  const MakeChatRoomEvent({
    required this.myUid,
    required this.friendUid,
  });

  @override
  List<Object> get props => [myUid, friendUid];
}

class MakeGroupRoomEvent extends ChatEvent {
  final GroupRoomModel groupRoom;
  final File image;
  const MakeGroupRoomEvent(this.groupRoom, this.image);

  @override
  List<Object> get props => [groupRoom, image];
}
