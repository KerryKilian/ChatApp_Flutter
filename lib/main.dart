import 'package:chatapp/layout/mobile_screen_layout.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/screens/start/login_screen.dart';
import 'package:chatapp/screens/start/signup_screen.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/providers/user_save.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: dotenv.env['API_KEY'] ?? '',
            appId: dotenv.env['APP_ID'] ?? '',
            messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'] ?? '',
            projectId: dotenv.env['PROJECT_ID'] ?? '',
            storageBucket: dotenv.env['STORAGE_BUCKET'] ?? ''));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  getUserData(String uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "ChatApp",
        theme: ThemeData(fontFamily: "Comfortaa"),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                // wenn snapshot Daten hat, dann ist user authenticated
                if (snapshot.hasData) {

                  // UserSave.setUser(snapshot.data as AppUser.AppUser);
                  return const MobileScreenLayout();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }

              // Wenn snapshot gar keine Daten hat -> User ist nicht eingeloggt
              return const SignupScreen();
            }));
  }
}
