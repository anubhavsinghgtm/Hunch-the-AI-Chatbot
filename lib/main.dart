// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:hunch/screens/welcome_screen.dart';
import 'package:hunch/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socket_io_client/socket_io_client.dart';

void main() async {
  // Socket socket = Socket.connect('192.168.43.84', 1234);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Socket socket;
  // MyApp(Socket s, {Key? key}) : super(key: key) {
  //   this.socket = s;
  //   s.listen(

  //         (Uint8List data) {
  //       final serverResponse = String.fromCharCodes(data);
  //       print('Server: $serverResponse');
  //     },

  //     // handle errors
  //     onError: (error) {
  //       print(error);
  //       s.destroy();
  //     },

  //     onDone: () {
  //       print('Server left.');
  //       s.destroy();
  //     },
  //   );
  // }

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      home: const WelcomeScreen(),
    );
  }
}
