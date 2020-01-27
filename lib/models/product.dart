import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../providers/fess_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String fullName;
  final DateTime dob;
  final DateTime joinDate;
  final String mobile;
  final String email;
  final String address;
  final String state;
  final String pinCode;
  DateTime lastFessPaidOn;
  int pendingMonths;
  int amount_till_now;
  int paidTillNow;
  bool isOnHold;

  Product({
    this.id,
    @required this.fullName,
    @required this.dob,
    @required this.joinDate,
    @required this.mobile,
    this.email,
    @required this.address,
    @required this.state,
    @required this.pinCode,
    this.amount_till_now = 0,
    this.lastFessPaidOn,
    this.pendingMonths,
    this.isOnHold = false,
  });
  void decrease_months(int months) {
    pendingMonths -= months;
    notifyListeners();
  }

  void toggle_hold(newValue) {
    isOnHold = newValue;
    notifyListeners();
  }

  void payment(var user_id, String full_name, int amount, int months, var fun,
      String receiver, String token) async {
    amount_till_now += amount;
    //pendingMonths -= months;

    fun.payment_add(user_id, full_name.toUpperCase(), amount.toString(), months,
        receiver, token);
    final url =
        'https://spartans-b1290.firebaseio.com/users/$user_id.json?auth=$token';
    try {
      final response = await http.patch(
        url,
        body: json.encode({'amount_till_now': amount_till_now}),
      );
      if (response.statusCode >= 400) {}
    } catch (error) {}
    notifyListeners();
  }

  Future<void> toggleIsPending(String tokens, String userId) async {
    final oldStatus = isOnHold;
    final newToggle = !isOnHold;
    isOnHold = !isOnHold;
    notifyListeners();

    final url =
        'https://spartans-b1290.firebaseio.com/users/$userId.json?auth=$tokens';
    try {
      final response = await http.patch(
        url,
        body: json.encode({'isOnHold': newToggle}),
      );
      if (response.statusCode >= 400) {
        toggle_hold(oldStatus);
      }
    } catch (error) {
      toggle_hold(oldStatus);
    }
  }
}
