import 'package:chatapp/models/chat.dart';
import 'package:chatapp/screens/chat/chat_card.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:chatapp/widgets/background.dart';
import 'package:chatapp/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  final String uid;
  const ChatListScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late List chatList = [];
  // late List messagesLists = [];
  var userSnap;

  @override
  void initState() {
    super.initState();
    getChats();
  }

  void getChats() async {
    userSnap = await FirebaseFirestore.instance.collection("users").doc(widget.uid).get();
    var chats = userSnap.data()!["chats"] as List;
    print(chats);
    // for (int i = 0; i < chats.length; i++) {
    //   chatList.add(await FirebaseFirestore.instance.collection("chats").doc(chats[i]).get());
    // }
    List<Future<DocumentSnapshot>> futures = [];
    List<Future<QuerySnapshot>> futureMessages = [];
    for (int i = 0; i < chats.length; i++) {
      // get chats
      futures.add(FirebaseFirestore.instance.collection("chats").doc(chats[i]).get());
      // // get messages from chats (in another collection)
      // futureMessages.add(FirebaseFirestore.instance.collection("chats").doc(chats[i]).collection("messages").get());
    }
    chatList = await Future.wait(futures);
    // messagesLists = await Future.wait(futureMessages);
    setState(() {
      chatList;
    });
  }

  Future<Map<String, dynamic>?> getOtherUserData(int index) async {
    if (chatList[index]["members"][0] == widget.uid) {
      var otherUserRef = await FirebaseFirestore.instance.collection("users").doc(chatList[index]["members"][1]).get();
      Map<String, dynamic> otherUser = (otherUserRef.data()) as Map<String, dynamic>;
      return otherUser;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
        child: SafeArea(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: const CustomText(text: "Chats", title: true),
          ),
          Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: chatList.length,
                        itemBuilder: (BuildContext context, int index) {
                          // var otherUser = getOtherUserData(index);
                          // if (otherUser != null) {
                          //   return Text("otherUser[username]");
                          // }
                          Map<String, dynamic> chat = chatList[index].data();
                          return ChatCard(chat: Chat(id: chat["id"], members: chat["members"], createdAt: chat["createdAt"], lastMessage: chat["lastMessage"] ?? "", lastTimestamp: chat["lastTimestamp"]), ownUserId: widget.uid,);
                          return Text(chatList[index].toString());
                      }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Constants.padding),
                    child: CustomText(text: "Klicke auf die Lupe in der Navigation, um neue Chats zu finden"),
                  )
                ],
              ),
          )
        ],
      ),
    ));
  }
}
