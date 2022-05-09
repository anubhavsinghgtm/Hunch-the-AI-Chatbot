import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../model/ChatMessage.dart';

class AudioMessage extends StatelessWidget {
  final ChatMessage message;

  const AudioMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.55,
      height: 40,
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: kPrimaryColor.withOpacity(message.isSender ? 1 : 0.2),
      ),
      child: Row(
        children: [
          Icon(
            Icons.play_arrow,
            color: message.isSender ? Colors.white : kPrimaryColor,
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: message.isSender
                        ? Colors.white
                        : kPrimaryColor.withOpacity(0.4),
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: message.isSender ? Colors.white : kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            '0.37',
            style: TextStyle(
                fontSize: 12, color: message.isSender ? Colors.white : null),
          ),
        ],
      ),
    );
  }
}
