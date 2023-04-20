import 'package:dash_playground/providers/installation_provider.dart';
import 'package:dash_playground/ui/dash_playgrounds_app.dart';

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
        create: (_) => InstallationProvider(),
      ),
    ],
    child: const DashPlaygroundApp(),
  ));
}
