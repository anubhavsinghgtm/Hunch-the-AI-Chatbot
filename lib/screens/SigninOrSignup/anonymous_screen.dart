import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:socket_io_client/socket_io_client.dart';
import 'dart:io';

import '../../components/primary_button.dart';
import '../../components/rounded_input_field.dart';
import '../chat/chat_screen.dart';
import '../clientProgramming/test.dart';

class AnonymousScreen extends StatelessWidget {
  AnonymousScreen({Key? key}) : super(key: key);
  final TextEditingController _nameTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(
                flex: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        Text(
                          "Anonymous",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Enter Your Private Zone',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color
                                  ?.withOpacity(0.8)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
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
                flex: 1,
              ),
              Center(
                  child: RoundedInputField(
                      validator: (value) {
                        RegExp regExp = new RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return ("Please enter your Password");
                        }
                      },
                      hintText: "Your Name",
                      controller: _nameTextController,
                      onChanged: (value) {})),
              const Spacer(
                flex: 1,
              ),
              PrimaryButton(
                text: "Continue",
                press: () async {
                  signIn();
                  Socket socket = await connectMe();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessageScreen(socket: socket),
                    ),
                  );
                },
                key: null,
              ),
              const Spacer(
                flex: 8,
              )
            ],
          ),
        ),
      ),
    );
  }

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      FirebaseAuth.instance.signInAnonymously();
    }
  }

  connectMe() async {
    Socket socket = await Socket.connect('178.62.234.199', 3000);

    return socket;
  }
}
