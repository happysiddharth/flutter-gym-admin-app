import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/fess.dart';

class FessRecord with ChangeNotifier {
  final token;
  FessRecord(this.token);
  List<Fess> _data = [];

  List<Fess> get data {
    return [..._data];
  }

  Future<void> transactions() async {
    var url =
        'https://spartans-b1290.firebaseio.com/fessrecord.json?auth=$token';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final List<Fess> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Fess(
            userId: prodData['userId'].toString(),
            fullname: prodData['fullname'],
            amount: prodData['amount'],
            date_of_submition: prodData['date_of_submition'],
            months: prodData['months'],
            receiver: prodData['receiver'],
          ),
        );
      });
      _data = loadedProducts.reversed.toList();

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  List<Fess> returnById(String id) {
    List<Fess> l = [];
    print(l.length);
    _data.forEach((data) => {
          print(data.months),
          if (data.userId == id)
            {
              l.add(data),
            }
        });
    print(l.length);

//    List<Fess> l = _data
//        .where((data) => data != null
//            ? data.userId.toString().contains("-Lz6yAqKV1fu3okitZ0Q")
//            : [])
//        .toList();
    return l;
  }

  Future<void> payment_add(String user_id, String fullname, String amount,
      var months, String receiver, String token) async {
    final url = 'https://spartans-b1290.firebaseio.com/fessrecord.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'userId': user_id,
          'fullname': fullname,
          'amount': amount,
          'date_of_submition': DateTime.now().toIso8601String(),
          'months': months,
          'receiver': receiver,
        }),
      );
      final newProduct = Fess(
          userId: user_id,
          fullname: fullname,
          amount: amount,
          date_of_submition: DateTime.now(),
          months: months);
      _data.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
