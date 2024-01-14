part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatSuccess extends ChatState {}

final class ChatError extends ChatState {
  final String e;
  const ChatError(this.e);

  @override
  List<Object> get props => [e];
}

final class GetChatListSuccess extends ChatState {
  final List<ChatRoomModel> data;
  const GetChatListSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class GetGroupListSuccess extends ChatState {
  final List<GroupRoomModel> data;
  const GetGroupListSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class GetAllMessageSuccess extends ChatState {
  final List<MessageModel> data;
  const GetAllMessageSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class GetLastMessageSuccess extends ChatState {
  final MessageModel data;
  const GetLastMessageSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class GetUnreadMessageSuccess extends ChatState {
  final int data;
  const GetUnreadMessageSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class MakeChatRoomSuccess extends ChatState {
  final ChatRoomModel data;
  const MakeChatRoomSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class MakeGroupRoomSuccess extends ChatState {
  final GroupRoomModel data;
  const MakeGroupRoomSuccess(this.data);

  @override
  List<Object> get props => [data];
}
