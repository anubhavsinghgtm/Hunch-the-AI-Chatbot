import 'package:flutter/material.dart';
import 'package:hunch/components/text_field_container.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String dropdownValue = 'Male';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextFieldContainer(
      child: Row(
        children: [
          Icon(
            Icons.male,
            color: Colors.black45,
          ),
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
              items: <String>['Male', 'Female', 'Trans', 'Other']
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
      validator: null,
    );
  }
}
