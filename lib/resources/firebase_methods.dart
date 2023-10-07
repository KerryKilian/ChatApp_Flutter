
import 'package:chatapp/models/message.dart';
import 'package:chatapp/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseMethods {

  /**
   * creates a new chat between two users
   */
  Future<String> createChat(String user1, String user2, BuildContext context) async {
    try {
      // add chat document
      CollectionReference chats = FirebaseFirestore.instance.collection('chats');
      DocumentReference newChatRef = await chats.add({
        'members': [user1, user2],
        "createdAt": FieldValue.serverTimestamp(),
      });
      String chatId = newChatRef.id;
      // add id to document
      await newChatRef.update({'id': chatId});

      // retrieve user document and update for currentUser
      DocumentReference currentUserRef = FirebaseFirestore.instance.collection('users').doc(user1);
      var currentUser = await currentUserRef.get();

      if (currentUser.exists) {
        await currentUserRef.update({
          'chats': FieldValue.arrayUnion([chatId]),
        });
      } else {
        print('User not found.');
      }

      DocumentReference profileUserRef = FirebaseFirestore.instance.collection('users').doc(user2);
      var profileUser = await profileUserRef.get();

      if (profileUser.exists) {
        await profileUserRef.update({
          'chats': FieldValue.arrayUnion([chatId]),
        });
      } else {
        print('User not found.');
      }
      return chatId;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    return "";
  }

  /**
   * Check if user has already a chat with another user
   */
  Future<String?> searchChat(String user1, String user2) async {
    try {
      // get user object
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user1);
      DocumentSnapshot user = await userRef.get();
      Map<String, dynamic> data = user.data() as Map<String, dynamic>;
      dynamic chatIds = data['chats'];

      if (chatIds != null || chatIds.isNotEmpty) {
        print(chatIds);
        // get all chats
        CollectionReference chatsRef = FirebaseFirestore.instance.collection('chats');
        QuerySnapshot chats = await chatsRef
            .where(FieldPath.documentId, whereIn: chatIds)
            .get();

        String? chatId;

        // Iterate through chats and find a match
        for (var chatDocument in chats.docs) {
          Map<String, dynamic> chatData = chatDocument.data() as Map<String, dynamic>;
          List<dynamic> members = chatData['members'];

          if (members.contains(user2)) {
            print(chatData["id"]);
            chatId = chatData["id"];
            break; // Exit the loop once a match is found
          }
        }

        return chatId; // Return the chat ID if a match was found
      }

    } catch (e) {
      print(e);
    }

    return null;
  }

  void writeMessage(Message message) async {
    CollectionReference messagesCollection = FirebaseFirestore.instance
        .collection('chats')
        .doc(message.chatId)
        .collection('messages');

    messagesCollection
        .add(message.toFirestoreData()) // Convert the Message object to Firestore data
        .then((DocumentReference documentRef) {
      print('Message added with ID: ${documentRef.id}');
    })
        .catchError((error) {
      print('Error adding message: $error');
    });


    // add last message and last timestamp to chat
    DocumentReference chatRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(message.chatId);
    Map<String, dynamic> data = {
      "lastMessage": message.text,
      "lastTimestamp": message.timestamp,
    };

    try {
      await chatRef.update(data);
      print("Document updated successfully");
    } catch (e) {
      print("Error updating document: $e");
    }
  }
}