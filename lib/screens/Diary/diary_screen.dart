import 'dart:math';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hunch/components/primary_button.dart';
import 'package:hunch/components/text_field_container.dart';
import 'package:hunch/model/ChatMessage.dart';
import 'package:hunch/model/dairy_model.dart';
import 'package:hunch/screens/Diary/savedScreen.dart';
import 'package:hunch/screens/Diary/select_feelings.dart';

import '../../constants.dart';

class DiaryScreen extends StatelessWidget {
  DiaryScreen({Key? key}) : super(key: key);

  final _thoughtController = TextEditingController();
  static List<dynamic> datalist = [];

  // database reference
  final firebaseRef = FirebaseDatabase(
          databaseURL:
              "https://hunch-test-app-default-rtdb.asia-southeast1.firebasedatabase.app/")
      .ref();

  // firebase auth reference
  final FirebaseAuth auth = FirebaseAuth.instance;

  final _feelingController = TextEditingController();
  final now = DateTime.now().toString().substring(0, 10);
  int maxId = 0;

  // void _save() {
  //   final thought = _thoughtController.text;
  //   final dailyThought = database.child('dailyThought');
  //   dailyThought.set({'thought': thought, 'date': now, 'Feeling': "Feelings"});
  //   print("done");
  //   //   //final date = _dateController.text;
  //   //   //final feeling = _feelingController.text;
  //
  // }
  void insertData(String thought, String feeling) {
    FocusManager.instance.primaryFocus
        ?.unfocus(); //to dismiss the onscreen keyboard
    final user = auth.currentUser;
    final uid = user!.uid;
    firebaseRef.child("Dairy/$uid").push().set({
      "Thought": thought,
      "Date": now,
      // "feeling": SelectFeelings().itemTexts
    });
    _thoughtController.clear();
    Fluttertoast.showToast(msg: "Saved");
  }

  // User getCurrentUser() {
  //   var currentUser;
  //   FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //     if (user != null) {
  //       currentUser = user;
  //       print(user.uid);
  //     }
  //   });
  //   return currentUser;
  // }

  String dropdownValue = 'Great';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Dear Diary"),
        actions: [
          Center(
            child: GestureDetector(
              child: Text('View Saved'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewSavedScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            width: kDefaultPadding / 2,
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(
              flex: 4,
            ),
            // Text(now),
            const Spacer(
              flex: 1,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
              width: size.width * 0.8,
              height: size.width * 0.6,
              decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: _thoughtController,
                //onChanged: onChanged,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  hintText: "Type here",
                  border: InputBorder.none,
                ),
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            const Text("How are you feeling now?"),
            const Spacer(
              flex: 1,
            ),
            SelectFeelings(),
            const Spacer(
              flex: 1,
            ),
            PrimaryButton(
                key: key,
                text: 'Save',
                press: () {
                  insertData(_thoughtController.text, _feelingController.text);
                }),
            const Spacer(
              flex: 8,
            ),
          ],
        ),
      ),
    );
  }

  static Future<List<dynamic>> getData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase(
            databaseURL:
                "https://hunch-test-app-default-rtdb.asia-southeast1.firebasedatabase.app/")
        .ref()
        .child('Dairy/$uid');

    // Query query = ref.orderByKey().limitToLast(1);

    ref.once().then((event) {
      datalist.clear();
      Map<dynamic, dynamic>? values = event.snapshot.value as Map?;
      final testValue = event.snapshot.children;
      // print(event.snapshot);
      // print(testValue.length);
      // print(values);
      for (var element in testValue) {
        datalist.add(element.value);
      }
      print("done");
      print(datalist);
      return datalist;
    });

    // ref.once().then((event) {
    //   datalist.clear();
    //   Object? values = event.snapshot.value;
    //   String? s = event.previousChildKey;
    //   int maxId = int.parse(s!);
    //   print(values);
    // });
    // print(datalist);
    // return datalist;
    return datalist;
  }
}

// class DairyDatabase {
//   // database reference
//   final firebaseRef = FirebaseDatabase(
//           databaseURL:
//               "https://hunch-test-app-default-rtdb.asia-southeast1.firebasedatabase.app/")
//       .ref();

//   // firebase auth reference
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   static List<dynamic> datalist = [];

//   static Future<List<dynamic>> getData() async {
//     final uid = FirebaseAuth.instance.currentUser!.uid;
//     final ref = FirebaseDatabase(
//             databaseURL:
//                 "https://hunch-test-app-default-rtdb.asia-southeast1.firebasedatabase.app/")
//         .ref()
//         .child('Dairy/$uid');

//     Query query = ref.orderByKey().limitToLast(1);

//     // ref.once().then((event) {
//     //   datalist.clear();
//     //   Map<dynamic, dynamic>? values = event.snapshot.value as Map?;
//     //   values?.forEach((key, value) {
//     //     datalist.add(value);
//     //     print(value);
//     //   });
//     //   print(datalist);
//     //   return datalist;
//     // });

//     query.once().then((event) {
//       datalist.clear();
//       Object? values = event.snapshot.value;
//       String? s = event.previousChildKey;
//       int maxId = int.parse(s!);
//       print(values);
//     });
//     print(datalist);
//     return datalist;

//     // print(datalist.length);
//     // return datalist;
//   }
// }

class SelectFeelings extends StatefulWidget {
  // SelectFeelings({
  //   Key? key,
  //   required this.controller,
  // });

  late String Function(String) itemTexts;

  @override
  State<SelectFeelings> createState() => _SelectFeelingsState();
}

class _SelectFeelingsState extends State<SelectFeelings> {
  String dropdownValue = "Great";
  String itemText = '';

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
              hint: const Text("Select Feeling"),
              value: dropdownValue,
              menuMaxHeight: 200,
              icon: const Icon(Icons.keyboard_arrow_down),
              elevation: 16,
              style: const TextStyle(color: Colors.black54, fontSize: 16),
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  itemText = dropdownValue;
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

  String itemTexts(String itemText) {
    return itemText;
  }
}
