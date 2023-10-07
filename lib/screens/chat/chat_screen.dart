import 'package:chatapp/models/message.dart';
import 'package:chatapp/resources/firebase_methods.dart';
import 'package:chatapp/screens/chat/message_card.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:chatapp/utils/utils.dart';
import 'package:chatapp/widgets/background.dart';
import 'package:chatapp/widgets/custom_icon_button.dart';
import 'package:chatapp/widgets/custom_text.dart';
import 'package:chatapp/widgets/text_field_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String profileUserId;
  final String chatId;

  const ChatScreen({Key? key, required this.currentUserId, required this.profileUserId, required this.chatId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Map<String, dynamic> profileUser = {};
  final TextEditingController _messageController = TextEditingController();
  FirebaseMethods firebaseMethods = FirebaseMethods();
  late Stream<QuerySnapshot> messagesStream = getAllMessagesStream(widget.chatId);

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final DocumentReference chatRef =
    FirebaseFirestore.instance.collection("chats").doc(widget.chatId);
    final DocumentSnapshot chat = await chatRef.get();


    DocumentReference profileUserRef = FirebaseFirestore.instance.collection("users").doc(widget.profileUserId);
    DocumentSnapshot profileUserSnap = await profileUserRef.get();
    profileUser = profileUserSnap.data() as Map<String, dynamic>;
    setState(() {
      profileUser;
    });
  }

  void sendMessage() async {
    try {
      Message message = Message(chatId: widget.chatId, sendFrom: widget.currentUserId, sendTo: widget.profileUserId, text: _messageController.text, timestamp: Timestamp.now());
      firebaseMethods.writeMessage(message);
      _messageController.text = "";
    } catch (e) {
      showSnackBar(e.toString(), context);
    }


  }

  Stream<QuerySnapshot> getAllMessagesStream(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void goBack() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: Constants.padding,),
              Row(
                children: [
                  SizedBox(width: Constants.padding,),
                  CustomIconButton(icon: Icons.arrow_back, onTap: goBack),
                  SizedBox(width: Constants.padding,),
                  CustomText(text: profileUser["username"] ?? "", title: true,)
                ],
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: messagesStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      }

                      // Process and display your messages here
                      final messages = snapshot.data!.docs; // List of message documents

                      // Render your UI with the messages
                      return ListView.builder(
                        itemCount: messages.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          final messageData = messages[index].data() as Map<String, dynamic>;
                          Message message = Message(chatId: messageData["chatId"], sendFrom: messageData["sendFrom"], sendTo: messageData["sendTo"], text: messageData["text"], timestamp: messageData["timestamp"]);
                          // Create a Message object from messageData or use it as needed

                          return ListTile(
                            title: MessageCard(message: message, currentUsersMessage: widget.currentUserId == message.sendFrom,),
                            // Other message fields can be displayed here
                          );
                        },
                      );
                    },
                  )
              ),
              Container(
                padding: EdgeInsets.all(Constants.padding),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFieldInput(
                          textEditingController: _messageController,
                          text: "",
                          textInputType: TextInputType.text,
                          maxLines: 5,
                          hintText: "Nachricht schreiben...",),
                      ),
                      SizedBox(width: Constants.padding,),
                      CustomIconButton(icon: Icons.send, onTap: sendMessage)
                    ],
                  )
              ),

            ],
          ),
        )
    );
  }
}
