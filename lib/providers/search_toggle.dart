import 'package:flutter/foundation.dart';

class SearchToggle with ChangeNotifier {
  bool search = false;
  bool tog_search = false;
  String search_string = '';

  void toggle_search_on() {
    tog_search = true;
    notifyListeners();
  }

  void toggle_search_off() {
    tog_search = false;
    notifyListeners();
  }

  void add_string(String s) {
    search_string = s;
    notifyListeners();
  }

  void toggle() {
    search = !search;
    tog_search = false;
    search_string = '';
    notifyListeners();
  }
}
