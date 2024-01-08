part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class GetAllPersonalChatEvent extends ChatEvent {
  final String uid;
  const GetAllPersonalChatEvent(this.uid);

  @override
  List<Object> get props => [uid];
}

class GetAllMessageEvent extends ChatEvent {
  final String roomId;
  const GetAllMessageEvent(this.roomId);

  @override
  List<Object> get props => [roomId];
}

class SendMessageEvent extends ChatEvent {
  final String roomId;
  final ChatModel message;
  const SendMessageEvent(this.roomId, this.message);

  @override
  List<Object> get props => [roomId, message];
}
