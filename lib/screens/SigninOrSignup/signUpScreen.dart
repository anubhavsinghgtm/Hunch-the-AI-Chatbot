import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hunch/components/primary_button.dart';
import 'package:hunch/components/rounded_input_field.dart';
import 'package:hunch/components/rounded_password_field.dart';
import 'package:hunch/components/text_field_container.dart';
import 'package:hunch/constants.dart';
import 'package:hunch/model/user_model.dart';
import 'package:hunch/screens/SigninOrSignup/signInScreen.dart';

import '../../components/alread_have_an_account.dart';
import '../../components/anonymous.dart';
import '../chat/chat_screen.dart';
import 'anonymous_screen.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameTextController = TextEditingController();

  final TextEditingController _emailTextController = TextEditingController();

  final TextEditingController _passwordTextController = TextEditingController();

  final TextEditingController _confirmPasswordTextController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Spacer(
                flex: 8,
              ),
              Text(
                "Create An Account",
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(
                flex: 2,
              ),

              // to take input of name
              RoundedInputField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Enter Your Name");
                    }
                    if (!RegExp("^[a-zA-z]").hasMatch(value)) {
                      return ("Please enter a valid Name");
                    }
                    return null;
                  },
                  hintText: "Your Name",
                  controller: _nameTextController,
                  onChanged: (value) {}),
              const Spacer(
                flex: 1,
              ),

              // to take input of email
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
                  icon: Icons.email,
                  onChanged: (value) {}),
              const Spacer(
                flex: 1,
              ),

              // to take input of password
              RoundedPasswordField(
                  validator: (value) {
                    RegExp regExp = new RegExp(r'^.{6,}$');
                    if (value!.isEmpty) {
                      return ("Please enter your Password");
                    }
                    if (!regExp.hasMatch(value)) {
                      return ("Please enter a valid password(length = 6)");
                    }
                  },
                  hintText: "Password",
                  controller: _passwordTextController,
                  onChanged: (value) {}),
              const Spacer(
                flex: 1,
              ),

              // to confirm the password
              RoundedPasswordField(
                  validator: (value) {
                    RegExp regExp = new RegExp(r'^.{6,}$');
                    if (_confirmPasswordTextController.text.length > 6 &&
                        _passwordTextController.text !=
                            _confirmPasswordTextController.text) {
                      return "Password doesn't match";
                    }
                    return null;
                  },
                  onChanged: (value) {},
                  controller: _confirmPasswordTextController,
                  hintText: "Confirm Password"),
              const Spacer(
                flex: 1,
              ),

              // sign button
              PrimaryButton(
                  text: 'Sign Up',
                  press: () async {
                    if (validate()) {
                      Socket socket = await connectMe();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MessageScreen(
                                  socket: socket,
                                )),
                      );
                    }
                  }),
              const Spacer(
                flex: 1,
              ),
              AlreadyHaveAnAccount(
                  login: false,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SigninOrSignupScreen()),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  connectMe() async {
    Socket socket = await Socket.connect('178.62.234.199', 3000);

    return socket;
  }

  bool validate() {
    if (!_emailTextController.text.isEmpty &&
        !_nameTextController.text.isEmpty &&
        !_passwordTextController.text.isEmpty &&
        !_confirmPasswordTextController.text.isEmpty) {
      signUp(_emailTextController.text, _passwordTextController.text);
    } else {
      Fluttertoast.showToast(msg: "All fields are required");
      return false;
    }
    return false;
  }

  Future<bool> signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passwordTextController.text)
          .then((value) {
        Fluttertoast.showToast(msg: "Success");
      }).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
      return true;
    }
    return false;
  }
}
