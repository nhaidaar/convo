import 'package:convo/models/chat_model.dart';
import 'package:convo/models/chatroom_model.dart';
import 'package:convo/services/chat_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<GetAllPersonalChatEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        final personalChats =
            await ChatService().getAllPersonalChats(event.uid);
        emit(GetAllChatSuccess(personalChats));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
    on<GetAllMessageEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        final messages = await ChatService().getAllMessages(event.roomId);
        emit(GetAllMessageSuccess(messages));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
    on<SendMessageEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        await ChatService().sendMessage(event.roomId, event.message);
        emit(ChatSuccess());
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
  }
}
