// controllers/chat_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hostelchat/chatmodel.dart';

class ChatController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String text) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final message = Message(senderId: currentUser.uid, text: text);
      await _firestore.collection('messages').add({
        'senderId': message.senderId,
        'text': message.text,
        'timestamp': Timestamp.now(),
      });
    }
  }

  Stream<QuerySnapshot> getMessages() {
    return _firestore.collection('messages').orderBy('timestamp').snapshots();
  }
}
