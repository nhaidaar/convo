class GroupRoomModel {
  final String? roomId;
  final String? admin;
  final List<String>? members;
  final String? title;
  final String? groupPicture;

  GroupRoomModel({
    this.roomId,
    this.admin,
    this.members,
    this.title,
    this.groupPicture,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'admin': admin,
      'members': members,
      'title': title,
      'groupPicture': groupPicture,
    };
  }

  factory GroupRoomModel.fromMap(Map<String, dynamic> map) {
    return GroupRoomModel(
      roomId: map['roomId'] ?? '',
      admin: map['admin'] ?? '',
      members: List<String>.from(map['members']),
      title: map['title'] ?? '',
      groupPicture: map['groupPicture'] ?? '',
    );
  }

  GroupRoomModel copyWith({
    String? roomId,
    String? admin,
    List<String>? members,
    String? title,
    String? groupPicture,
  }) =>
      GroupRoomModel(
        roomId: roomId ?? this.roomId,
        admin: admin ?? this.admin,
        members: members ?? this.members,
        title: title ?? this.title,
        groupPicture: groupPicture ?? this.groupPicture,
      );
}
