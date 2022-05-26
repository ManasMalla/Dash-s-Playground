import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  var isDarkMode = false;
  changeThemeMode(ThemeMode themeMode) {
    isDarkMode = themeMode == ThemeMode.dark;
    notifyListeners();
  }
}

class ThemeConfig {
  static bool themeMode = false;
  static var background = Colors.grey.shade50;
  static var primary = const Color(0xFF01579b);
  static var onBackground = const Color(0xFF01579b);
  init(context) {
    var provider = Provider.of<ThemeProvider>(context, listen: true);
    themeMode = provider.isDarkMode;
    if (provider.isDarkMode) {
      background = const Color(0xFF121212);
      primary = const Color(0xFF54c5f8);
      onBackground = Colors.white;
    } else {
      background = Colors.grey.shade50;
      primary = const Color(0xFF01579b);
      onBackground = const Color(0xFF01579b);
    }
    provider.addListener(() {
      // themeMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
      // print(themeMode);
      // background = (themeMode ? Color(0xFF121212) : Colors.grey.shade50);
      themeMode = provider.isDarkMode;
      if (provider.isDarkMode) {
        background = const Color(0xFF121212);
        primary = const Color(0xFF54c5f8);
        onBackground = Colors.white;
      } else {
        background = Colors.grey.shade50;
        primary = const Color(0xFF01579b);
        onBackground = const Color(0xFF01579b);
      }
    });
  }
}
