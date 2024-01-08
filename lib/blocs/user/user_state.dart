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

final class UserStorageSuccess extends UserState {
  final String url;
  const UserStorageSuccess(this.url);

  @override
  List<Object> get props => [url];
}
