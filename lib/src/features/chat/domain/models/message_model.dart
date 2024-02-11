class MessageModel {
  final String? roomId;
  final String? image;
  final String? message;
  final String? sendBy;
  final String? sendAt;
  final List<String>? readBy;
  final List<String>? readAt;
  final List<String>? hiddenFor;

  MessageModel({
    this.roomId,
    this.image,
    this.message,
    this.sendBy,
    this.sendAt,
    this.readBy,
    this.readAt,
    this.hiddenFor,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId ?? '',
      'image': image ?? '',
      'message': message ?? '',
      'sendBy': sendBy ?? '',
      'sendAt': sendAt ?? '',
      'readBy': readBy ?? [],
      'readAt': readAt ?? [],
      'hiddenFor': hiddenFor ?? [],
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      roomId: map['roomId'] ?? '',
      image: map['image'] ?? '',
      message: map['message'] ?? '',
      sendBy: map['sendBy'] ?? '',
      sendAt: map['sendAt'] ?? '',
      readBy: List<String>.from(map['readBy']),
      readAt: List<String>.from(map['readAt']),
      hiddenFor: List<String>.from(map['hiddenFor']),
    );
  }
}
