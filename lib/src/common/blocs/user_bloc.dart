import 'dart:io';

import 'package:convo/src/common/models/user_model.dart';
import 'package:convo/src/common/services/user_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService _userService = UserService();

  UserBloc() : super(UserInitial()) {
    on<StreamUserDataEvent>(
      (event, emit) async {
        await emit.onEach(
          _userService.streamUserData(event.uid),
          onData: (data) => emit(UserStreamDataSuccess(data)),
          onError: (error, stackTrace) => emit(UserError(error.toString())),
        );
      },
    );
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
        } else {
          emit(const UserError('User not found!'));
        }
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
    on<GetSelfDataEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final model = await UserService().getSelfData();
        if (model != null) {
          emit(UserGetDataSuccess(model));
        } else {
          emit(const UserError('User not found!'));
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
    on<UpdateUserDataEvent>((event, emit) async {
      emit(UserLoading());
      try {
        await UserService().updateUserData(event.model);
        emit(UserSuccess());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
    on<CheckUsernameEvent>((event, emit) async {
      emit(UserLoading());
      try {
        await UserService().checkUsername(event.username).then((usernameTaken) {
          usernameTaken ? emit(const UserError('Username taken!')) : emit(UsernameAvailable());
        });
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
