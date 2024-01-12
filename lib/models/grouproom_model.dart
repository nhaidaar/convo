class GroupRoomModel {
  final String? roomId;
  final List<String>? members;
  final String? title;
  final String? groupPicture;

  GroupRoomModel({
    this.roomId,
    this.members,
    this.title,
    this.groupPicture,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'members': members,
      'title': title,
      'groupPicture': groupPicture,
    };
  }

  factory GroupRoomModel.fromMap(Map<String, dynamic> map) {
    return GroupRoomModel(
      roomId: map['roomId'] ?? '',
      members: List<String>.from(map['members']),
      title: map['title'] ?? '',
      groupPicture: map['groupPicture'] ?? '',
    );
  }

  GroupRoomModel copyWith({
    String? roomId,
    List<String>? members,
    String? title,
    String? groupPicture,
  }) =>
      GroupRoomModel(
        roomId: roomId ?? this.roomId,
        members: members ?? this.members,
        title: title ?? this.title,
        groupPicture: groupPicture ?? this.groupPicture,
      );
}
