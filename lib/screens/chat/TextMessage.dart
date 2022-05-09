import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../model/ChatMessage.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    required this.message,
    Key? key,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(message.isSender ? 1 : 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        message.text,
        style: TextStyle(
            color: message.isSender
                ? Colors.white
                : Theme.of(context).textTheme.bodyText1!.color),
      ),
    );
  }
}
