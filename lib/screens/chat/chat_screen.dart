// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hunch/constants.dart';
import 'package:hunch/model/ChatMessage.dart';
import 'package:hunch/screens/Diary/diary_screen.dart';
import 'package:hunch/screens/SigninOrSignup/signInScreen.dart';
import 'package:hunch/screens/chat/TextMessage.dart';
import 'package:hunch/screens/chat/chat_input_screen.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'message.dart';

class MessageScreen extends StatefulWidget {
  final Socket socket;
  const MessageScreen({
    required this.socket,
    Key? key,
  }) : super(key: key);

  // final ChatMessage message;

  @override
  State<MessageScreen> createState() => _MessageScreenState(socket);
}

class _MessageScreenState extends State<MessageScreen> {
  final Socket socket;
  ChatDatabase chatDatabase = ChatDatabase();
  ScrollController scrollController = ScrollController();

  String botReply = '';

  _MessageScreenState(this.socket);

  @override
  void initState() {
    super.initState();
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        // leading: Image.asset(
        //   'assets/icons/logo.png',
        //   height: size.height * 0.01,
        // ),
        title: Text('Hunch AI'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DiaryScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add_circle),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                Fluttertoast.showToast(msg: "Logged out");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SigninOrSignupScreen(),
                  ),
                );
              });
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: widget.socket,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(snapshot.hasData
                    ? botReply =
                        String.fromCharCodes(snapshot.data as Uint8List)
                    : ''),
              );
            },
          ),
          Expanded(
            child: FirebaseAnimatedList(
              controller: scrollController,
              query: chatDatabase.getMessageQuery(),
              itemBuilder: (context, snapshot, animation, index) {
                final json = snapshot.value as Map<dynamic, dynamic>;
                final message = ChatMessage.fromJson(json);
                return Messages(message: message);
              },
            ),
          ),
          ChatInputScreen(
            socket: socket,
          ),
        ],
      ),
    );
  }

  void scrollDown() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
    // _scrollController.animateTo(
    //   0.0,
    //   curve: Curves.easeOut,
    //   duration: const Duration(milliseconds: 300),
    // );
  }
}
