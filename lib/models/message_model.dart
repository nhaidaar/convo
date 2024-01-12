import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String message;
  final DateTime sendAt;
  final String sendBy;

  MessageModel({
    required this.message,
    required this.sendAt,
    required this.sendBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'sendAt': sendAt,
      'sendBy': sendBy,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      message: map['message'] ?? '',
      sendAt: (map['sendAt'] as Timestamp).toDate(),
      sendBy: map['sendBy'] ?? '',
    );
  }
}
