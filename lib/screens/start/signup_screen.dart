import 'dart:typed_data';

import 'package:chatapp/layout/mobile_screen_layout.dart';
import 'package:chatapp/resources/auth_methods.dart';
import 'package:chatapp/screens/start/login_screen.dart';
import 'package:chatapp/utils/colors.dart';
import 'package:chatapp/utils/utils.dart';
import 'package:chatapp/widgets/background.dart';
import 'package:chatapp/widgets/custom_button.dart';
import 'package:chatapp/widgets/custom_icon_button.dart';
import 'package:chatapp/widgets/custom_text.dart';
import 'package:chatapp/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        file: _image!,
        bio: _bioController.text);
    setState(() {
      _isLoading = false;
    });

    if (res != "success") {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MobileScreenLayout()));
    }
  }

  void navigateToLogin() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoginScreen()));
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Background(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                CustomText(
                  text: "Registrieren",
                  title: true,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomText(
                    text: "Registriere dich jetzt kostenlos, um zu chatten."),
                SizedBox(
                  height: 20,
                ),
                TextFieldInput(
                  textEditingController: _usernameController,
                  text: "Benutzername",
                  textInputType: TextInputType.text,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFieldInput(
                    textEditingController: _emailController,
                    text: "Email",
                    textInputType: TextInputType.emailAddress),
                SizedBox(
                  height: 20,
                ),
                TextFieldInput(
                  textEditingController: _passwordController,
                  text: "Passwort",
                  textInputType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFieldInput(
                  textEditingController: _bioController,
                  text: "Bio",
                  textInputType: TextInputType.text,
                  obscureText: false,
                ),
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                "https://as1.ftcdn.net/v2/jpg/00/64/67/80/1000_F_64678017_zUpiZFjj04cnLri7oADnyMH0XBYyQghG.jpg"),
                          ),
                    Positioned(
                        bottom: -0,
                        left: 80,
                        child: CustomIconButton(
                          onTap: selectImage,
                          icon: Icons.add_a_photo,
                        )
                        // IconButton(
                        //   onPressed: () {
                        //     selectImage();
                        //   },
                        //   icon: const Icon(
                        //     Icons.add_a_photo,
                        //     color: primaryColor,
                        //   ),
                        // )

                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                CustomButton(
                  text: "Bestätigen",
                  onTapFunction: signUpUser,
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: navigateToLogin,
                  child: CustomText(
                    text: "Du hast bereits einen Account? Einloggen",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
