import 'package:flutter/material.dart';

class SplashScreenProvider extends ChangeNotifier {
  var percentage = 0.0;
  updatePercentage(value) {
    percentage = value;
    notifyListeners();
  }
}
