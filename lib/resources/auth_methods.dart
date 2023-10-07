import 'package:chatapp/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'package:chatapp/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.AppUser> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection("users").doc(currentUser.uid).get();
    return model.AppUser.fromSnap(snap);
  }

  Future<String> signUpUser(
      {required String username,
      required String email,
      required String password,
      required Uint8List file,
      required String bio}) async {
    String res = "Ein Fehler ist aufgetreten";
    try {
      if (username.isNotEmpty ||
          email.isNotEmpty ||
          password.isNotEmpty ||
          file.isNotEmpty ||
          bio.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String photoUrl = await StorageMethods()
            .uploadImageToStorage("profileImages", file, false);
        print(cred.user!.uid);
        model.AppUser user = model.AppUser(
            email: email,
            uid: cred.user!.uid,
            photoUrl: photoUrl,
            username: username,
            bio: bio,
            chats: []);
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = "Konto erfolgreich erstellt";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "invalid-email") {
        res = "The email is badly formatted";
      } else if (err.code == "weak-password") {
        res = "Password should be at least 6 characters";
      } else {
        res = err.code;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Bitte fülle alle Felder aus.";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        res = "Benutzer nicht gefunden. Registriere dich zunächst.";
      } else if (e.code == "wrong-password") {
        res = "Falsches Passwort.";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
