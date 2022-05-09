import 'package:flutter/cupertino.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 8,
            ),
            Text(
              "Anonymous Login",
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.bold),
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
                Fluttertoast.showToast(msg: "Anonymously Logged in");
                Socket socket = await connectMe();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => MyHomePage(socket: socket)),
                // );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MessageScreen(
                            socket: socket,
                          )),
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
    );
  }

  connectMe() async {
    Socket socket = await Socket.connect('178.62.234.199', 3000);

    return socket;
  }
}
