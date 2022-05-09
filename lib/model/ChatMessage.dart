import 'package:flutter/cupertino.dart';

class ChatMessage {
  final String text;
  final String messageType;
  final bool isSender;

  ChatMessage(
      {required this.text, required this.messageType, required this.isSender});

  ChatMessage.fromJson(Map<dynamic, dynamic> json)
      : text = json['text'] as String,
        messageType = json['messageType'],
        isSender = json['isSender'] as bool;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'text': text,
        'messageType': messageType,
        'isSender': isSender
      };

  static updateMessages(text, messageType, isSender) {
    demoChatMessages.add(
        ChatMessage(text: text, messageType: messageType, isSender: isSender));
    print("Added");
  }
}

List firebaseChatMessages = [];

List demoChatMessages = [
  ChatMessage(
      text: "Hi there, I am Hunch", messageType: 'text', isSender: false),
  ChatMessage(
      text: "ok, I will be there in some moment",
      messageType: 'text',
      isSender: true),
  ChatMessage(text: "no, i am good", messageType: 'text', isSender: false),
  ChatMessage(
      text: "thank you for your kind support",
      messageType: 'text',
      isSender: true),
  ChatMessage(
      text: "ok, I will be there in some moment",
      messageType: 'audio',
      isSender: false),
  ChatMessage(
      text: "I think I can help you in it",
      messageType: 'text',
      isSender: true),
  ChatMessage(
      text: "Yes, can help you in it?", messageType: 'audio', isSender: true),
];
