import 'package:flutter/material.dart';
import 'package:hunch/model/dairy_model.dart';

import '../../constants.dart';
import '../../model/ChatMessage.dart';

class Thought extends StatelessWidget {
  const Thought({
    Key? key,
    required this.date,
    required this.thought,
  }) : super(key: key);

  final String date;
  final String thought;

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size

    return Container(
        margin: const EdgeInsets.all(kDefaultPadding),
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kDefaultPadding / 2,
        ),
        decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.50),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date),
            const SizedBox(
              height: 10,
            ),
            Text(
              thought,
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Feelings',
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .color
                      ?.withOpacity(0.6)),
            ),
          ],
        ));
  }
}
