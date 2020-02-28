import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class Products with ChangeNotifier {
  final token;
  Products(this.token);
  List<Product> _items = [

  ];
  List<Product> notOnholdItems() {
    List<Product> l = _items.where((data) => data.isOnHold == false).toList();
    return l;
  }

  List<Product> onHoldAndFessIsPending() {
    List<Product> l = _items
        .where((data) => data.isOnHold == true && data.pendingMonths > 0)
        .toList();
    return l;
  }

  List<Product> onHoldAndFessIsNotPending() {
    List<Product> l = _items
        .where((data) => data.isOnHold == true && data.pendingMonths == 0)
        .toList();
    return l;
  }

  List<Product> pendingFessUsers() {
    List<Product> l = _items
        .where((data) => data == null
            ? null
            : (DateTime.now().difference(data.lastFessPaidOn).inDays) >= 0)
        .toList();
    l.sort((a, b) {
      return DateTime.now()
          .difference(b.lastFessPaidOn)
          .inDays
          .compareTo(DateTime.now().difference(a.lastFessPaidOn).inDays);
    });
    return l;
  }

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchProduct() async {
    var url = 'https://spartans-b1290.firebaseio.com/users.json?auth=$token';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            fullName: prodData['fullName'],
            mobile: prodData['mobile'],
            email: prodData['email'],
            dob: DateTime.parse(prodData['dob']),
            address: prodData['address'],
            state: prodData['state'],
            pinCode: prodData['pinCode'],
            joinDate: DateTime.parse(prodData['joinDate']),
            pendingMonths: prodData['pendingMonths'],
            amount_till_now: prodData['amount_till_now'],
            isOnHold: prodData['isOnHold'],
            lastFessPaidOn: DateTime.parse(
              prodData['lastFessPaidOn'],
            ),
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> findByFullName(String fullname) {
    List<Product> l = _items
        .where((data) => data.fullName.toLowerCase().contains(fullname))
        .toList();
    return l;
  }

  void addUserv2(Product d) {
    _items.add(
      d,
    );
    notifyListeners();
  }

  Future<void> addUser(String fullname, String mobile, String email,
      DateTime dob, String address, String state, String pinCode) async {
    final url = 'https://spartans-b1290.firebaseio.com/users.json?auth=$token';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'fullName': fullname,
          'mobile': mobile,
          'amount_till_now': 0,
          'email': email,
          'dob': dob.toIso8601String(),
          'address': address,
          'state': state,
          'pinCode': pinCode,
          'joinDate': DateTime.now().toIso8601String(),
          'pendingMonths': 1,
          'isOnHold': false,
          'lastFessPaidOn': DateTime.now().toIso8601String(),
        }),
      );
      print(json.decode(response.body.toString())['name']);
      final newProduct = Product(
        id: json.decode(response.body.toString())['name'],
        fullName: fullname,
        mobile: mobile,
        email: email,
        dob: dob,
        address: address,
        state: state,
        pinCode: pinCode,
        joinDate: DateTime.now(),
        pendingMonths: 0,
      );
      addUserv2(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
    } catch (error) {
      throw error;
    }
  }
}
