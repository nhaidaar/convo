part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class StreamUserDataEvent extends UserEvent {
  final String uid;
  const StreamUserDataEvent(this.uid);

  @override
  List<Object> get props => [uid];
}

class GetUserDataEvent extends UserEvent {
  final String uid;
  const GetUserDataEvent(this.uid);

  @override
  List<Object> get props => [uid];
}

class PostUserDataEvent extends UserEvent {
  final UserModel user;
  const PostUserDataEvent(this.user);

  @override
  List<Object> get props => [user];
}

class UploadToStorageEvent extends UserEvent {
  final String uid;
  final File file;
  const UploadToStorageEvent({
    required this.uid,
    required this.file,
  });

  @override
  List<Object> get props => [uid, file];
}

class SearchUserEvent extends UserEvent {
  final String search;
  final String exceptUid;
  const SearchUserEvent({
    required this.search,
    required this.exceptUid,
  });

  @override
  List<Object> get props => [search, exceptUid];
}
