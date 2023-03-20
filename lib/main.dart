import 'package:dash_playground/providers/installation_provider.dart';
import 'package:dash_playground/ui/dash_playgrounds_app.dart';
import 'package:dash_playground/providers/theme_provider.dart';

import 'package:dash_playground/providers/splash_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => SplashScreenProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => InstallationProvider(),
      ),
    ],
    child: const DashPlaygroundApp(),
  ));
}

Future<void> setPrefThemeMode(BuildContext context) async {
  var systemThemeMode =
      WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
  var themeMode = systemThemeMode ? ThemeMode.dark : ThemeMode.light;
  Provider.of<ThemeProvider>(context, listen: false).changeThemeMode(themeMode);
}
