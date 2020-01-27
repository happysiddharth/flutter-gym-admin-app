import 'package:flutter/cupertino.dart';

class Fess {
  final userId;
  final fullname;
  final amount;
  final date_of_submition;
  final months;
  final receiver;
  Fess({
    @required this.userId,
    @required this.fullname,
    @required this.months,
    @required this.amount,
    @required this.date_of_submition,
    @required this.receiver,
  });
}
