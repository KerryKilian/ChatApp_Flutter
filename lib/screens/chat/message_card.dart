import 'package:chatapp/models/message.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:chatapp/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  final bool currentUsersMessage;
  const MessageCard({Key? key, required this.message, required this.currentUsersMessage}) : super(key: key);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {

  String convertTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd.MM.yy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.currentUsersMessage ? Alignment.centerRight : Alignment.centerLeft, // Align to the right
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Constants.padding),
            bottomLeft: Radius.circular(Constants.padding),
            topRight: Radius.circular(Constants.padding),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomText(
              text: widget.message.text,
              color: Colors.black,
            ),
            SizedBox(height: Constants.padding/2,),
            CustomText(
              text: convertTimestamp(widget.message.timestamp),
              color: Colors.black,
              fontSize: 10,
            )
          ],
        )
      ),
    );
  }
}
