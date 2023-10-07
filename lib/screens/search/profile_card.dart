import 'package:chatapp/screens/profile/profile_screen.dart';
import 'package:chatapp/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatefulWidget {
  final String uid;
  final Map<String, dynamic> user;
  const ProfileCard({Key? key, required this.uid, required this.user}) : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  
  @override
  void initState() {
    super.initState();
  }

  Future<List<QueryDocumentSnapshot>> searchUsers(String searchTerm) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: searchTerm)
        .get();
    return querySnapshot.docs;
  }

  void navigateToProfile() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProfileScreen(currentUserId: widget.uid, profileUserId: widget.user["uid"], profileUserData: widget.user)));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: navigateToProfile,
      child: Row(
        children: [
          Container(
            width: 50,
            margin: EdgeInsets.all(10),
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    widget.user["photoUrl"],
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: widget.user["username"], fontWeight: FontWeight.bold,),
              CustomText(text: widget.user["bio"])
            ],
          )
        ],
      ),
    );
  }
}
