import 'dart:io';

import 'package:convo/models/message_model.dart';
import 'package:convo/models/chatroom_model.dart';
import 'package:convo/models/grouproom_model.dart';
import 'package:convo/services/chat_services.dart';
import 'package:convo/services/user_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService _chatService = ChatService();

  ChatBloc() : super(ChatInitial()) {
    on<GetChatListEvent>(
      (event, emit) async {
        await emit.onEach(
          _chatService.streamChatList(event.uid),
          onData: (data) => emit(GetChatListSuccess(data)),
          onError: (error, stackTrace) => emit(ChatError(error.toString())),
        );
      },
    );
    on<GetGroupListEvent>(
      (event, emit) async {
        await emit.onEach(
          _chatService.streamGroupList(event.uid),
          onData: (data) => emit(GetGroupListSuccess(data)),
          onError: (error, stackTrace) => emit(ChatError(error.toString())),
        );
      },
    );
    on<GetAllMessageEvent>(
      (event, emit) async {
        await emit.onEach(
          _chatService.streamChat(event.roomId),
          onData: (data) => emit(GetAllMessageSuccess(data)),
          onError: (error, stackTrace) => emit(ChatError(error.toString())),
        );
      },
    );
    on<GetLastMessageEvent>(
      (event, emit) async {
        await emit.onEach(
          _chatService.streamLastMessage(event.roomId),
          onData: (data) => emit(GetLastMessageSuccess(data)),
          onError: (error, stackTrace) => emit(ChatError(error.toString())),
        );
      },
    );

    on<SendMessageEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        await _chatService.sendMessage(
            roomId: event.roomId, model: event.message);
        emit(ChatSuccess());
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<SendNotificationEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        final friends = await UserService().getUserToken(event.to);
        final me = await UserService().getUserData(event.from);
        await _chatService.sendPushNotification(
          pushTokens: friends,
          from: me!.displayName.toString(),
          msg: event.message,
        );
        emit(ChatSuccess());
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<MakeChatRoomEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        final data = await _chatService.makeChatRoom(
          myUid: event.myUid,
          friendUid: event.friendUid,
        );
        emit(MakeChatRoomSuccess(data));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<MakeGroupRoomEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        final data =
            await _chatService.makeGroupRoom(event.groupRoom, event.image);
        emit(MakeGroupRoomSuccess(data));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
  }
}
