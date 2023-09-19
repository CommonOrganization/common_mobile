import 'package:flutter/material.dart';

class ScreenController extends ChangeNotifier {
  void pageRefresh() {
    notifyListeners();
  }
}
