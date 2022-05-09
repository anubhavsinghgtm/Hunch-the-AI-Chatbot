import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../model/ChatMessage.dart';
import 'TextMessage.dart';
import 'audio_message.dart';

class Messages extends StatelessWidget {
  const Messages({
    Key? key,
    required this.message,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    Widget messageContaint(ChatMessage message) {
      switch (message.messageType) {
        case 'text':
          return TextMessage(message: message);
        case 'audio':
          return AudioMessage(message: message);
        default:
          return SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender) ...[
            const SizedBox(
              width: kDefaultPadding / 4,
            ),
            const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage("assets/icons/logo.png"),
            ),
          ],
          const SizedBox(
            width: kDefaultPadding / 2,
          ),
          messageContaint(message),
          const SizedBox(
            width: kDefaultPadding / 2,
          ),
        ],
      ),
    );
  }
}
