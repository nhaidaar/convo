part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserSuccess extends UserState {}

final class UserError extends UserState {
  final String e;
  const UserError(this.e);

  @override
  List<Object> get props => [e];
}

final class UserStreamDataSuccess extends UserState {
  final UserModel model;
  const UserStreamDataSuccess(this.model);

  @override
  List<Object> get props => [model];
}

final class UserGetDataSuccess extends UserState {
  final UserModel model;
  const UserGetDataSuccess(this.model);

  @override
  List<Object> get props => [model];
}

final class UserStoreFileSuccess extends UserState {
  final String url;
  const UserStoreFileSuccess(this.url);

  @override
  List<Object> get props => [url];
}

final class UserSearchSuccess extends UserState {
  final List<UserModel> userList;
  const UserSearchSuccess(this.userList);

  @override
  List<Object> get props => [userList];
}
