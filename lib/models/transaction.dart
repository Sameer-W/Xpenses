import 'package:flutter/foundation.dart';

class Transactions {
  final String id;
  final String title;
  final String comment;
  final double amount;

  final DateTime date;

  Transactions({
    @required this.id,
    @required this.title,
    this.comment,
    @required this.amount,
    @required this.date,
  });
}
