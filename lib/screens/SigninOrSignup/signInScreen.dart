import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hunch/components/alread_have_an_account.dart';
import 'package:hunch/components/anonymous.dart';
import 'package:hunch/components/primary_button.dart';
import 'package:hunch/components/rounded_input_field.dart';
import 'package:hunch/components/rounded_password_field.dart';
import 'package:hunch/screens/Diary/diary_screen.dart';
import 'package:hunch/constants.dart';
import 'package:hunch/screens/Diary/savedScreen.dart';
import 'package:hunch/screens/SigninOrSignup/signUpScreen.dart';
import 'package:hunch/screens/chat/chat_screen.dart';
import 'package:hunch/screens/welcome_screen.dart';

import '../../components/text_field_container.dart';
import 'anonymous_screen.dart';

class SigninOrSignupScreen extends StatefulWidget {
  SigninOrSignupScreen({Key? key}) : super(key: key);

  @override
  State<SigninOrSignupScreen> createState() => _SigninOrSignupScreenState();
}

class _SigninOrSignupScreenState extends State<SigninOrSignupScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Spacer(
                flex: 7,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello',
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Good Evening",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color
                                ?.withOpacity(0.8)),
                      ),
                    ],
                  ),
                  Image.asset(
                    MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? 'assets/icons/logo.png'
                        : 'assets/icons/logo.png',
                    height: size.height * 0.14,
                  ),
                ],
              ),
              const Spacer(
                flex: 2,
              ),
              RoundedInputField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Enter Your Email");
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return ("Please enter a valid email");
                    }
                    return null;
                  },
                  hintText: "Your Email",
                  controller: _emailTextController,
                  onChanged: (value) {}),
              const Spacer(
                flex: 1,
              ),
              RoundedPasswordField(
                hintText: "Password",
                controller: _passwordTextController,
                onChanged: (value) {},
              ),
              const Spacer(
                flex: 1,
              ),
              PrimaryButton(
                  text: "Sign In",
                  press: () {
                    SignIn(_emailTextController.text,
                        _passwordTextController.text);
                  }),
              const Spacer(
                flex: 1,
              ),
              AlreadyHaveAnAccount(press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              }),
              const Spacer(
                flex: 1,
              ),
              Anonymous(press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnonymousScreen(),
                  ),
                );
              }),
              const Spacer(
                flex: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void SignIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passwordTextController.text)
          .then((value) async {
        Fluttertoast.showToast(msg: "Loggedin Successful");
        Socket socket = await connectMe();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MessageScreen(socket: socket)));
      }).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  connectMe() async {
    Socket socket = await Socket.connect('178.62.234.199', 3000);

    return socket;
  }
}
