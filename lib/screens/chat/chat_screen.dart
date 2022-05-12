// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

// ignore_for_file: deprecated_member_use

import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hunch/components/show_exit_pop.dart';
import 'package:hunch/constants.dart';
import 'package:hunch/model/ChatMessage.dart';
import 'package:hunch/screens/Diary/diary_screen.dart';
import 'package:hunch/screens/SigninOrSignup/signInScreen.dart';
import 'package:hunch/screens/chat/TextMessage.dart';
import 'package:hunch/screens/chat/chat_databse.dart';
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
  final messageTextController = TextEditingController();
  late ChatMessage chatMessage;
  int length = 1;

  String botReply = '';

  _MessageScreenState(this.socket);

  @override
  void initState() {
    scrollDown();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        appBar: AppBar(
          // leading: Image.asset(
          //   'assets/icons/logo.png',
          //   height: size.height * 0.01,
          // ),
          title: const Text('Hunch AI'),
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
                  Navigator.pushReplacement(
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
                if (snapshot.hasData &&
                    length != snapshot.data.toString().length) {
                  length = snapshot.data.toString().length;
                  botReply = String.fromCharCodes(snapshot.data as Uint8List);
                  chatMessage = ChatMessage(
                      text: botReply, messageType: 'text', isSender: false);
                  chatDatabase.insertData(chatMessage);
                  scrollDown();
                }
                return const SizedBox(
                  height: 0,
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
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
                vertical: kDefaultPadding / 2,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 32,
                      color: kPrimaryColor.withOpacity(0.3)),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    const Icon(
                      Icons.mic,
                      color: kPrimaryColor,
                    ),
                    const SizedBox(
                      width: kDefaultPadding,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: kDefaultPadding),
                        height: 40,
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(40),
                        ),

                        // Input field of the message
                        child: TextFormField(
                          controller: messageTextController,
                          decoration: const InputDecoration(
                              hintText: 'Type your message',
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: kDefaultPadding,
                    ),
                    // Icon(Icons.send,
                    //     color: Theme.of(context)
                    //         .textTheme
                    //         .bodyText1!
                    //         .color!
                    //         .withOpacity(0.64)),
                    IconButton(
                        onPressed: () {
                          sendMessage();
                          scrollDown();

                          Future.delayed(const Duration(milliseconds: 150));
                        },
                        icon: const Icon(Icons.send)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void insertBotData() {
    String text = botReply;
    if (text.isNotEmpty) {
      final message =
          ChatMessage(text: text, messageType: 'text', isSender: false);
      chatDatabase.insertData(message);
    }
  }

  void sendMessage() {
    String messageText = messageTextController.text.trim();

    messageTextController.text = '';
    if (messageText.isNotEmpty) {
      final message =
          ChatMessage(text: messageText, messageType: 'text', isSender: true);
      chatDatabase.insertData(message);
      widget.socket.write(messageText);

      setState(() {});
    }

    ChatMessage.updateMessages(messageText, 'text', true);

    FocusManager.instance.primaryFocus?.unfocus();
  }

  void scrollDown() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  }
}
