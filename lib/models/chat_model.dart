import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String message;
  final DateTime sendAt;
  final String sendBy;

  ChatModel({
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

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      message: map['message'],
      sendAt: (map['sendAt'] as Timestamp).toDate(),
      sendBy: map['sendBy'],
    );
  }
}
