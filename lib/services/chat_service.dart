import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ChatService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUsers() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((document) {
        return <String, dynamic>{
          ...document.data(),
          'uid': document.data()['uid']?.toString() ?? document.id,
        };
      }).toList();
    });
  }

  String getChatRoomId(String userId, String otherUserId) {
    final ids = [userId, otherUserId]..sort();
    return ids.join('_');
  }

  Stream<List<MessageModel>> getMessages(String otherUserId) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw StateError('Sign in with Firebase to view messages.');
    }
    if (currentUser.uid == otherUserId) {
      throw ArgumentError('You cannot open a chat with yourself.');
    }

    return _firestore
        .collection('chat_rooms')
        .doc(getChatRoomId(currentUser.uid, otherUserId))
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((document) => MessageModel.fromMap(document.data()))
              .toList(),
        );
  }

  Future<void> sendMessage({
    required String receiverId,
    required String message,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw StateError('Sign in with Firebase to send messages.');
    }
    if (currentUser.uid == receiverId) {
      throw ArgumentError('You cannot send a message to yourself.');
    }

    final text = message.trim();
    if (text.isEmpty) return;

    final chatRoomId = getChatRoomId(currentUser.uid, receiverId);
    final messageModel = MessageModel(
      senderId: currentUser.uid,
      senderEmail: currentUser.email ?? '',
      receiverId: receiverId,
      message: text,
      timestamp: Timestamp.now(),
    );

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(messageModel.toMap());
  }
}
