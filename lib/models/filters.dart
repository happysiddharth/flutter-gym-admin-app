import 'package:flutter/foundation.dart';

enum Filter {
  no_hold_with_pending_e,
  on_hold_with_pendings_e,
  on_hold_with_no_pendings,
}

class Filters with ChangeNotifier {
  bool no_hold_with_pendings;
  bool on_hold_with_pendings;
  bool on_hold_with_no_pendings;
  bool all;
  Filters({
    this.no_hold_with_pendings = false,
    this.on_hold_with_pendings = false,
    this.on_hold_with_no_pendings = false,
    this.all = true,
  });
  void toggle(String t) {
    if (t == '0') {
      no_hold_with_pendings = !no_hold_with_pendings;
      notifyListeners();
    } else if (t == '1') {
      on_hold_with_pendings = !on_hold_with_pendings;
      notifyListeners();
    } else if (t == '3') {
      all = !all;
      notifyListeners();
    } else {
      on_hold_with_no_pendings = !on_hold_with_no_pendings;
      notifyListeners();
    }
  }
}
