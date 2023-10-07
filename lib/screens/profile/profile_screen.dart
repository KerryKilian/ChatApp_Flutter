import 'package:chatapp/models/user.dart';
import 'package:chatapp/providers/user_provider.dart';
import 'package:chatapp/resources/firebase_methods.dart';
import 'package:chatapp/screens/chat/chat_screen.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/utils.dart';
import 'package:chatapp/widgets/background.dart';
import 'package:chatapp/widgets/custom_icon_button.dart';
import 'package:chatapp/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  final String profileUserId;
  final Map<String, dynamic>? profileUserData;

  const ProfileScreen(
      {Key? key, required this.currentUserId, required this.profileUserId, this.profileUserData = null})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseMethods firebaseMethods = FirebaseMethods();
  var userData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {

    setState(() {
      _isLoading = true;
    });
    try {
      // if this is the users own profile, we need to load data. Because if it is the profile from another user, the data would come from widget.profileUserData
      if (widget.profileUserData == null) {
        var userSnap = await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.profileUserId)
            .get();
        userData = userSnap.data()!;
      } else {
        userData = widget.profileUserData;
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }


    setState(() {
      _isLoading = false;
    });
  }

  bool currentUserEqualsProfileUser() {
    return widget.currentUserId == widget.profileUserId;
  }

  /**
   * creates a chat or - if a chat exists - navigates to this chat
   */
  void chatOnClick() async {
    String? chat = await firebaseMethods.searchChat(widget.currentUserId, widget.profileUserId);
    print(chat);
    if (chat != null) {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(currentUserId: widget.currentUserId, profileUserId: widget.profileUserId, chatId: chat),
        ),
      );
    } else {
      String chatId = await firebaseMethods.createChat(widget.currentUserId, widget.profileUserId, context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(currentUserId: widget.currentUserId, profileUserId: widget.profileUserId, chatId: chatId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
        child: SafeArea(
      child: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          :
      Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                currentUserEqualsProfileUser()
                    ? CustomText(
                        text: "Mein Profil",
                        title: true,
                      )
                    : SizedBox(),
                Container(
                  width: 200,
                  margin: EdgeInsets.all(10),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          userData["photoUrl"],
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                CustomText(
                  text: userData["username"],
                  title: true,
                ),
                SizedBox(
                  height: 12,
                ),
                CustomText(text: userData["bio"]),
                SizedBox(
                  height: 12,
                ),
                SizedBox(height: 12,),
                currentUserEqualsProfileUser() ? SizedBox() :
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconButton(icon: Icons.close, onTap: () {Navigator.of(context).pop();}),
                    SizedBox(width: 12,),
                    CustomIconButton(icon: Icons.chat, onTap: chatOnClick)
                  ],
                )

              ],
            ),
    ));
  }
}
