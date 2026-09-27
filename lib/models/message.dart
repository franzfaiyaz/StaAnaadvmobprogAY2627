import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  const MessageModel({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    final value = map['timestamp'];
    return MessageModel(
      senderId: map['senderId']?.toString() ?? '',
      senderEmail: map['senderEmail']?.toString() ?? '',
      receiverId: map['receiverId']?.toString() ?? '',
      message: map['message']?.toString() ?? '',
      timestamp: value is Timestamp ? value : Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'senderEmail': senderEmail,
    'receiverId': receiverId,
    'message': message,
    'timestamp': timestamp,
  };
}
