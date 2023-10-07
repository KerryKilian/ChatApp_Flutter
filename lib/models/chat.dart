import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final List members;
  final List? messages;
  final Timestamp createdAt;
  final String lastMessage;
  final Timestamp? lastTimestamp;

  const Chat({
    required this.id,
    required this.members,
    this.messages,
    required this.createdAt,
    this.lastMessage = "",
    this.lastTimestamp,
  });
}
