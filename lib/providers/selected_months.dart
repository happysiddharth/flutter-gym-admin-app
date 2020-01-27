import 'package:flutter/material.dart';

class Months with ChangeNotifier {
  String selectedDate;
  Months({this.selectedDate = '1'});
  void changeDate(String date) {
    selectedDate = date;
    notifyListeners();
  }
}
