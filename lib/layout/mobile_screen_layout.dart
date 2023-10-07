import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MobileScreenLayout extends StatefulWidget {
  final double activeSize = 36;
  final double inactiveSize = 28;

  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        body: PageView(
          children: homeScreenItems,
          physics: NeverScrollableScrollPhysics(),
          // no scroll effect when scrolling left or right
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: Stack(
          children: [
            Container(
              // padding: EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    fourthColor,
                    fifthColor,
                  ],
                ),
              ),
              height: 65,
            ),
            CupertinoTabBar(
              height: 65,
              backgroundColor: Colors.transparent,
              activeColor: primaryColor,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.chat_bubble_sharp,
                      color: _page == 0 ? primaryColor : secondaryColor,
                      size: _page == 0
                          ? widget.activeSize
                          : widget.inactiveSize,
                    ),
                    label: "",
                    backgroundColor: primaryColor),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                      color: _page == 1 ? primaryColor : secondaryColor,
                      size: _page == 1
                          ? widget.activeSize
                          : widget.inactiveSize,
                    ),
                    label: "",
                    backgroundColor: primaryColor),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search,
                      color: _page == 2 ? primaryColor : secondaryColor,
                      size: _page == 2
                          ? widget.activeSize
                          : widget.inactiveSize,
                    ),
                    label: "",
                    backgroundColor: primaryColor),
              ],
              onTap: navigationTapped,
            ),

          ],
        ));
  }
}
