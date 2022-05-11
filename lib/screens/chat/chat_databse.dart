import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:hunch/model/ChatMessage.dart';

class ChatDatabase {
  final firebaseRef = FirebaseDatabase(
          databaseURL:
              "https://hunch-test-app-default-rtdb.asia-southeast1.firebasedatabase.app/")
      .ref();

  // firebase auth reference
  final FirebaseAuth auth = FirebaseAuth.instance;

  static List<dynamic> datalist = [];

  // to push the chat messages to the firebase database
  void insertData(ChatMessage message) {
    final user = auth.currentUser;
    final uid = user!.uid;
    firebaseRef.child('Chat/$uid').push().set(message.toJson());
    Fluttertoast.showToast(msg: "Saved");
  }

  // query to the firebase
  Query getMessageQuery() {
    final user = auth.currentUser;
    final uid = user!.uid;
    return firebaseRef.child('Chat/$uid');
  }
}
