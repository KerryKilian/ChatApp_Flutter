import 'dart:convert';

import 'package:chatapp/screens/search/profile_card.dart';
import 'package:chatapp/widgets/background.dart';
import 'package:chatapp/widgets/custom_icon_button.dart';
import 'package:chatapp/widgets/custom_text.dart';
import 'package:chatapp/widgets/text_field_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final String uid;
  const Search({Key? key, required this.uid}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = TextEditingController();

  // List<Map<String, dynamic>> userList = [];
  List<Map<String, dynamic>> searchUserList = [];
  bool _searchActive = false;

  @override
  void initState() {
    super.initState();
    // getChats();
  }

  // void getChats() async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
  //   List<DocumentSnapshot> users = querySnapshot.docs;
  //   userList = users.map((DocumentSnapshot snapshot) {
  //     return snapshot.data() as Map<String, dynamic>;
  //   }).toList();
  //   setState(() {
  //     userList;
  //   });
  //   return;
  // }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void searchUser() async {
    // print("Search User now !!!!");
    // String inputLower = _searchController.text.toLowerCase();
    // String inputUpper = _searchController.text.toUpperCase();

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("username", isEqualTo: _searchController.text)
        .get();
    searchUserList = querySnapshot.docs.map((DocumentSnapshot snapshot) {
      return snapshot.data() as Map<String, dynamic>;
    }).toList();
    // print(searchUserList);

    setState(() {
      // userList = [];
      // _searchActive = true;
      searchUserList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
        child: SafeArea(
      child: Container(
        margin: EdgeInsets.all(12),
        child: Column(
          children: [
            const CustomText(
              text: "Suche",
              title: true,
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFieldInput(
                      textEditingController: _searchController,
                      text: "Suche Personen",
                      textInputType: TextInputType.text),
                ),
                SizedBox(
                  width: 12,
                ),
                CustomIconButton(icon: Icons.search, onTap: searchUser)
              ],
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: searchUserList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ProfileCard(uid: widget.uid, user: searchUserList[index]);
                    }))
            //     : ListView.builder(
            // itemCount: searchUserList.length,
            // itemBuilder: (BuildContext context, int index) {
            //   return ProfileCard(user: userList[index]);
            // }))
          ],
        ),
      ),
    ));
  }
}
