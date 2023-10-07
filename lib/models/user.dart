import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppUser {
  final String username;
  final String email;
  final String uid;
  final String photoUrl;
  final String bio;
  final List chats;

  const AppUser({
    required this.username,
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.bio,
    required this.chats,
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "uid": uid,
    "photoUrl": photoUrl,
    "bio": bio,
    "chats": []
  };

  static AppUser fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return AppUser(
        username: snapshot["username"],
        email: snapshot["email"],
        uid: snapshot["uid"],
        photoUrl: snapshot["photoUrl"],
        bio: snapshot["bio"],
        chats: snapshot["chats"]);
  }
}
