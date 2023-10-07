import 'package:chatapp/screens/chat_list_screen.dart';
import 'package:chatapp/screens/profile/profile_screen.dart';
import 'package:chatapp/screens/search/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  print("no image selected");
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

List<Widget> homeScreenItems = [
  ChatListScreen(
      uid: FirebaseAuth.instance.currentUser!.uid
  ),
  ProfileScreen(
    currentUserId: FirebaseAuth.instance.currentUser!.uid,
    profileUserId: FirebaseAuth.instance.currentUser!.uid,// the same, because it is profile screen of current user
  ),
  Search(
      uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
