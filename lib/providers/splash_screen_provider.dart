import 'package:flutter/material.dart';

class SplashScreenProvider extends ChangeNotifier {
  var percentage = 0.0;
  var hasNetworkAvailable = false;
  //The boolean status of the splash screen
  var isLoaded = false;

  updatePercentage(value) {
    percentage = value;
    notifyListeners();
  }

  updateNetworkAvailability() {
    hasNetworkAvailable = true;
    notifyListeners();
  }

  void updateLoadedState() {
    isLoaded = true;
    notifyListeners();
  }
}
