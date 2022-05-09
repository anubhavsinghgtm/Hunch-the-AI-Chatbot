import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hunch/components/text_field_container.dart';
import 'package:hunch/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  FormFieldValidator<String>? validator;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  RoundedInputField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.icon = Icons.person,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          icon: Icon(
            icon,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
      validator: validator,
    );
  }
}
