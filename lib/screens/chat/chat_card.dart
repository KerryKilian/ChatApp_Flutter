import 'package:chatapp/models/chat.dart';
import 'package:chatapp/screens/chat/chat_screen.dart';
import 'package:chatapp/screens/profile/profile_screen.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:chatapp/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatefulWidget {
  final Chat chat;
  final String ownUserId;
  const ChatCard({Key? key, required this.chat, required this.ownUserId}) : super(key: key);

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  String otherUserId = "";
  late Map<String, dynamic> otherUserData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getOtherUserId();
    getOtherUserData();
  }

  void getOtherUserId() {
    if (widget.chat.members[0] == widget.ownUserId) {
      otherUserId = widget.chat.members[1];
    }
    else {
      otherUserId = widget.chat.members[0];
    }
  }

  void getOtherUserData() async {
    var otherUserRef = await FirebaseFirestore.instance.collection("users").doc(otherUserId).get();
    Map<String, dynamic> otherUser = (otherUserRef.data()) as Map<String, dynamic>;
    setState(() {
      otherUserData = otherUser;
      _isLoading = false;
    });
  }

  String truncateString(String input) {
    if (input.length <= 50) {
      return input;
    } else {
      return input.substring(0, 50) + "...";
    }
  }

  void navigateToChat() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChatScreen(currentUserId: widget.ownUserId, profileUserId: otherUserId, chatId: widget.chat.id)));
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading == true ? Center(child: CircularProgressIndicator()) : InkWell(
      onTap: navigateToChat,
      child: Column(
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                margin: EdgeInsets.only(left: Constants.padding, right: Constants.padding),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        otherUserData?["photoUrl"] ?? "",
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: otherUserData?["username"] ?? "", fontWeight: FontWeight.bold),
                  // SizedBox(height: Constants.padding/2,),
                  CustomText(text: truncateString(widget.chat.lastMessage != null || widget.chat.lastMessage != "" ? widget.chat.lastMessage : "Nachricht schreiben")),
                ],
              ),
            ],
          ),
          SizedBox(height: Constants.padding,)
        ],
      ),
    );
  }
}
