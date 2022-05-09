import 'package:flutter/material.dart';
import 'package:hunch/constants.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  FormFieldValidator<String>? validator;
  TextFieldContainer({
    Key? key,
    required this.child,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
      width: size.width * 0.8,
      decoration: BoxDecoration(
          color: kSecondaryColor, borderRadius: BorderRadius.circular(29)),
      child: child,
    );
  }
}
