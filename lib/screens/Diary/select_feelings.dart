import 'package:flutter/material.dart';
import 'package:hunch/components/text_field_container.dart';

class SelectFeelings extends StatefulWidget {
  TextEditingController controller = TextEditingController();

  SelectFeelings({
    Key? key,
    required this.controller,
  });

  @override
  State<SelectFeelings> createState() => _SelectFeelingsState();
}

class _SelectFeelingsState extends State<SelectFeelings> {
  String dropdownValue = "Great";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextFieldContainer(
      validator: null,
      child: Row(
        children: [
          SizedBox(
            width: size.width * 0.05,
          ),
          Container(
            width: 200,
            child: DropdownButton<String>(
              value: dropdownValue,
              menuMaxHeight: 200,
              icon: const Icon(Icons.keyboard_arrow_down),
              elevation: 16,
              style: const TextStyle(color: Colors.black54, fontSize: 16),
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>['Great', 'Good', 'Bad', 'Worse']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
