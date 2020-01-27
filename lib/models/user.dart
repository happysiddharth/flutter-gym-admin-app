import 'package:flutter/material.dart';

class User {
  User(
      {this.id,
      @required this.fullname,
      @required this.phone,
      @required this.email,
      @required this.address,
      @required this.state,
      @required this.pincode,
      @required this.dob});
  final id;
  final fullname;
  final phone;
  final email;
  final address;
  final state;
  final pincode;
  final dob;
}
