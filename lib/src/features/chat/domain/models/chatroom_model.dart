class ChatRoomModel {
  final String? roomId;
  final List<String>? members;

  ChatRoomModel({
    this.roomId,
    this.members,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'members': members,
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      roomId: map['roomId'] ?? '',
      members: List<String>.from(map['members']),
    );
  }
}
