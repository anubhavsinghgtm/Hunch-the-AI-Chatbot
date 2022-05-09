import 'package:flutter/material.dart';
import 'package:hunch/components/text_field_container.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hintText;
  final TextEditingController controller;
  FormFieldValidator<String>? validator;

  RoundedPasswordField({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.hintText,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: controller,
        obscureText: true,
        onChanged: onChanged,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          icon: const Icon(
            Icons.lock,
          ),
          hintText: hintText,
          border: InputBorder.none,
          suffixIcon: const Icon(
            Icons.visibility,
          ),
        ),
      ),
      validator: validator,
    );
  }
}
