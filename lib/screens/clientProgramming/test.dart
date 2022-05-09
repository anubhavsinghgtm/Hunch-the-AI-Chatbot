import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hunch/components/primary_button.dart';
import 'package:hunch/components/rounded_input_field.dart';
import 'package:hunch/components/text_field_container.dart';
import 'package:hunch/main.dart';

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:hunch/model/ChatMessage.dart';

class MyHomePage extends StatefulWidget {
  final Socket socket;
  const MyHomePage({
    Key? key,
    required this.socket,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<MyHomePage> createState() => _MyHomePageState(socket);
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController messageController = TextEditingController();
  final Socket socket;
  late ScrollController _controller;

  _MyHomePageState(this.socket);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(
            flex: 1,
          ),
          StreamBuilder(
            stream: widget.socket,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(snapshot.hasData
                    ? String.fromCharCodes(snapshot.data as Uint8List)
                    : ''),
              );
            },
          ),
          RoundedInputField(
              hintText: "Enter your message",
              controller: messageController,
              onChanged: (value) {}),
          PrimaryButton(
              text: "Send",
              press: () {
                // Socket socket = await connectIt(host, port);
                send();
              }),
          PrimaryButton(
              text: "Disconnect",
              press: () async {
                print("clicked on disconnect");
              }),
          const Spacer(
            flex: 1,
          )
        ],
      ),
    );
  }

  void send() {
    String messageText = messageController.text.trim();
    String time = DateTime.now().toString().substring(0, 16);
    messageController.text = '';
    print(messageText);
    if (messageText.isNotEmpty) {
      widget.socket.write(messageText);
      var messagePost = {
        'message': messageText,
        'isSender': true,
        'time': DateTime.now().toString().substring(0, 16),
      };
    }
    ChatMessage.updateMessages(messageText, true, time);
  }

  @override
  void dispose() async {
    widget.socket.close();
    super.dispose();
  }
}
