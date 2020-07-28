import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  static const String id = 'history-page';
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Transactions'),
      ),
      body: Column(children: <Widget>[]),
    );
  }
}
