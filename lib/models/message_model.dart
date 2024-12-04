import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String? text;
  final String? imageUrl;
  final DateTime timestamp;

  Message({
    required this.senderId,
    this.text,
    this.imageUrl,
    required this.timestamp,
  });

  //  Firestore document > Message object
  factory Message.fromDocument(Map<String, dynamic> doc) {
    return Message(
      senderId: doc['senderId'],
      text: doc['text'],
      imageUrl: doc['imageUrl'],
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
    );
  }

  //  Message object >  map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
    };
  }
}
