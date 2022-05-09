import 'package:flutter/material.dart';

import '../constants.dart';

class AlreadyHaveAnAccount extends StatelessWidget {
  final bool login;
  final void Function() press;

  const AlreadyHaveAnAccount({
    this.login = true,
    required this.press,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(login ? "Don't have an account? " : "Already have an account? "),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? 'REGISTER' : 'Log In',
            style: const TextStyle(
                color: kPrimaryColor, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
