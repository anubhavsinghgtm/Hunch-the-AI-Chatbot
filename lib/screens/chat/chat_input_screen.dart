import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hunch/constants.dart';
import 'package:hunch/model/ChatMessage.dart';
import 'package:hunch/screens/chat/chat_screen.dart';

class ChatInputScreen extends StatefulWidget {
  ChatInputScreen({Key? key, required this.socket}) : super(key: key);
  final Socket socket;

  @override
  State<ChatInputScreen> createState() => _ChatInputScreenState(socket);
  // ignore: non_constant_identifier_names
  late Function getText;
}

class _ChatInputScreenState extends State<ChatInputScreen> {
  final Socket socket;
  // message controller - to take input from the textfield
  final messageTextController = TextEditingController();
  ChatDatabase chatDatabase = ChatDatabase();
  String botReply = '';

  final auth = FirebaseAuth.instance;
  final firebaseRef = FirebaseDatabase(
          databaseURL:
              "https://hunch-test-app-default-rtdb.asia-southeast1.firebasedatabase.app/")
      .ref();

  _ChatInputScreenState(this.socket);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 4),
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
                      hintText: 'Type your message', border: InputBorder.none),
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
                  // send();
                  Future.delayed(const Duration(milliseconds: 150));

                  insertBotData(ChatBotData(socket).getReply());
                  print("coming back");
                },
                icon: const Icon(Icons.send)),
          ],
        ),
      ),
    );
  }

  void insertBotData(String text) {
    if (text.isNotEmpty) {
      final message =
          ChatMessage(text: text, messageType: 'text', isSender: false);
      chatDatabase.insertData(message);
    } else {
      print('empty text');
    }
  }

// message send
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
}

class ChatDatabase {
  final firebaseRef = FirebaseDatabase(
          databaseURL:
              "https://hunch-test-app-default-rtdb.asia-southeast1.firebasedatabase.app/")
      .ref();

  // firebase auth reference
  final FirebaseAuth auth = FirebaseAuth.instance;

  static List<dynamic> datalist = [];

  // to push the chat messages to the firebase database
  void insertData(ChatMessage message) {
    final user = auth.currentUser;
    final uid = user!.uid;
    firebaseRef.child('Chat/$uid').push().set(message.toJson());
    Fluttertoast.showToast(msg: "Saved");
  }

  // query to the firebase
  Query getMessageQuery() {
    final user = auth.currentUser;
    final uid = user!.uid;
    return firebaseRef.child('Chat/$uid');
  }

  static Future<List<dynamic>> getData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase(
            databaseURL:
                "https://hunch-test-app-default-rtdb.asia-southeast1.firebasedatabase.app/")
        .ref()
        .child('Chat/$uid');

    ref.once().then((event) {
      datalist.clear();
      Map<dynamic, dynamic>? values = event.snapshot.value as Map?;
      values?.forEach((key, value) {
        datalist.add(value);
      });

      return datalist;
    });
    print(datalist);
    return datalist;
  }
}

class ScrollDown {
  void scrollDown(ScrollController scrollController) {
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

class MessageScreen extends StatefulWidget {
  final Socket socket;
  const MessageScreen({
    required this.socket,
    Key? key,
  }) : super(key: key);

  // final ChatMessage message;

  @override
  State<MessageScreen> createState() => ChatBotData(socket);
}

class ChatBotData extends State<MessageScreen> {
  //ChatDatabase chatDatabase = ChatDatabase();
  ScrollController scrollController = ScrollController();

  String botReply = '';

  ChatBotData(Socket socket);
  @override
  void initState() {
    super.initState();
  }

  //ChatBotData(Socket socket, {Key? key, required this.socket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
        ],
      ),
    );
  }

  String getReply() {
    return botReply;
  }
}
