import 'package:convo/models/user_model.dart';

class GroupRoomModel {
  final String? roomId;
  final List<String>? members;
  final List<UserModel>? interlocutors;

  GroupRoomModel({
    this.roomId,
    this.members,
    this.interlocutors,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'members': members,
    };
  }

  factory GroupRoomModel.fromMap(Map<String, dynamic> map) {
    return GroupRoomModel(
      roomId: map['roomId'],
      members: List<String>.from(map['members']),
    );
  }
}
