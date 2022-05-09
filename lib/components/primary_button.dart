import 'package:flutter/material.dart';
import 'package:hunch/constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {Key? key,
      required this.text,
      required this.press,
      this.width = double.infinity,
      this.color = kPrimaryColor,
      this.padding = const EdgeInsets.all(kDefaultPadding * 0.75)})
      : super(key: key);

  final String text;
  final VoidCallback press;
  final color;
  final EdgeInsets padding;
  final width;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      padding: padding,
      color: color,
      minWidth: size.width * 0.8,
      onPressed: press,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
