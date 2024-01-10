import 'dart:io';

import 'package:convo/models/user_model.dart';
import 'package:convo/services/user_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UploadToStorageEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final url = await UserService().uploadImageToStorage(
          uid: event.uid,
          image: event.file,
        );
        emit(UserStoreFileSuccess(url));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
    on<PostUserDataEvent>((event, emit) async {
      emit(UserLoading());
      try {
        await UserService().postUserData(event.user);
        emit(UserSuccess());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
    on<GetUserDataEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final model = await UserService().getUserData(event.uid);
        if (model != null) {
          emit(UserGetDataSuccess(model));
        }
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
    on<SearchUserEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final userList = await UserService().searchUser(
          search: event.search,
          exceptUid: event.exceptUid,
        );
        emit(UserSearchSuccess(userList));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
