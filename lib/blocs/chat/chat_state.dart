part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class GetAllChatSuccess extends ChatState {
  final List<ChatRoomModel> data;
  const GetAllChatSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class GetAllMessageSuccess extends ChatState {
  final List<ChatModel> data;
  const GetAllMessageSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class ChatSuccess extends ChatState {}

final class ChatError extends ChatState {
  final String e;
  const ChatError(this.e);

  @override
  List<Object> get props => [e];
}
