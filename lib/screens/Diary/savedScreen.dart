import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hunch/model/dairy_model.dart';
import 'package:hunch/screens/Diary/diary_screen.dart';
import 'package:hunch/screens/Diary/thought.dart';

import '../../model/ChatMessage.dart';

class ViewSavedScreen extends StatefulWidget {
  const ViewSavedScreen({Key? key}) : super(key: key);

  @override
  State<ViewSavedScreen> createState() => _ViewSavedScreenState();
}

class _ViewSavedScreenState extends State<ViewSavedScreen> {
  List<dynamic> _dataList = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _setupDatalist();
    scrollDown();
  }

  _setupDatalist() async {
    List<dynamic> dataList = await DiaryScreen.getData();
    setState(() {
      _dataList = dataList;
    });
  }

  void scrollDown() {
    // _scrollController.animateTo(
    //   _scrollController.position.maxScrollExtent,
    //   duration: const Duration(seconds: 2),
    //   curve: Curves.fastOutSlowIn,
    // );
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Thought'),
      ),
      body: Center(
          child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: _dataList.length,
              itemBuilder: (context, index) => Thought(
                date: _dataList[index]['Date'],
                thought: _dataList[index]['Thought'],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
