import 'dart:io';

import 'package:convo/config/method.dart';
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
          _chatService.streamChatList(),
          onData: (data) => emit(GetChatListSuccess(data)),
          onError: (error, stackTrace) => emit(ChatError(error.toString())),
        );
      },
    );
    on<GetGroupListEvent>(
      (event, emit) async {
        await emit.onEach(
          _chatService.streamGroupList(),
          onData: (data) => emit(GetGroupListSuccess(data)),
          onError: (error, stackTrace) => emit(ChatError(error.toString())),
        );
      },
    );
    on<GetSameGroupListEvent>(
      (event, emit) async {
        await emit.onEach(
          _chatService.streamSameGroup(event.uid),
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
    on<GetUnreadMessageEvent>(
      (event, emit) async {
        await emit.onEach(
          _chatService.streamUnreadMessage(event.roomId),
          onData: (data) => emit(GetUnreadMessageSuccess(data)),
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
          from: '${me!.displayName} ${event.groupTitle}',
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
        // Check is chat room already exists
        await _chatService
            .isChatRoomExists(
          myUid: event.myUid,
          friendUid: event.friendUid,
        )
            .then((value) async {
          // If true, pass the ChatRoomModel
          if (value != null) {
            emit(MakeChatRoomSuccess(value));

            // If false, make the chat room
          } else {
            await _chatService
                .makeChatRoom(
                  myUid: event.myUid,
                  friendUid: event.friendUid,
                )
                .then((value) => emit(MakeChatRoomSuccess(value)));
          }
        });
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

    on<SaveImageEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        await saveImage(event.url);
        emit(ChatSuccess());
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<DeleteChatEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        await _chatService.deleteChatRoom(event.roomId);
        emit(ChatSuccess());
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<LeaveGroupEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        await _chatService.leaveGroup(event.roomId);
        emit(ChatSuccess());
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
  }
}
