part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UploadToStorageEvent extends UserEvent {
  final String uid;
  final File file;
  const UploadToStorageEvent(this.uid, this.file);

  @override
  List<Object> get props => [uid, file];
}

class PostUserDataEvent extends UserEvent {
  final UserModel user;
  const PostUserDataEvent(this.user);

  @override
  List<Object> get props => [user];
}

class GetUserDataEvent extends UserEvent {
  final String uid;
  const GetUserDataEvent(this.uid);

  @override
  List<Object> get props => [uid];
}
