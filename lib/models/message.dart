import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String chatId;
  final String sendFrom;
  final String sendTo;
  final String text;
  final Timestamp timestamp; // Add this field

  const Message({
    required this.chatId,
    required this.sendFrom,
    required this.sendTo,
    required this.text,
    required this.timestamp, // Initialize the timestamp field
  });

  // You can add a factory constructor to create a Message object from a Firestore document
  factory Message.fromFirestore(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    return Message(
      chatId: data['chatId'] ?? '',
      sendFrom: data['sendFrom'] ?? '',
      sendTo: data['sendTo'] ?? '',
      text: data['text'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(), // Initialize timestamp with current time if not available
    );
  }

  // You can also add a method to convert the Message object to a Firestore document data map
  Map<String, dynamic> toFirestoreData() {
    return {
      'chatId': chatId,
      'sendFrom': sendFrom,
      'sendTo': sendTo,
      'text': text,
      'timestamp': timestamp,
    };
  }
}