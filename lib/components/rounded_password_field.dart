import 'package:flutter/material.dart';
import 'package:hunch/components/text_field_container.dart';

// ignore: must_be_immutable
class RoundedPasswordField extends StatefulWidget {
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
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: widget.controller,
        obscureText: _isObscure,
        onChanged: widget.onChanged,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          icon: const Icon(
            Icons.lock,
          ),
          hintText: widget.hintText,
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              _isObscure ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          ),
        ),
      ),
      validator: widget.validator,
    );
  }
}
