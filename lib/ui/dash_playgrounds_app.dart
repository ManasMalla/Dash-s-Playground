import 'package:dash_playground/ui/splash_screen.dart';
import 'package:dash_playground/ui/theme/color_schemes.g.dart';
import 'package:flutter/material.dart';

import '../home_screen.dart';

class DashPlaygroundApp extends StatefulWidget {
  const DashPlaygroundApp({Key? key}) : super(key: key);

  @override
  State<DashPlaygroundApp> createState() => _DashPlaygroundAppState();
}

class _DashPlaygroundAppState extends State<DashPlaygroundApp>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      initialRoute: 'splash-screen',
      theme: ThemeData(
          useMaterial3: true,
          navigationDrawerTheme: NavigationDrawerThemeData(
              indicatorColor: lightColorScheme.primary),
          colorScheme: lightColorScheme,
          fontFamily: "Google Sans"),
      darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          navigationDrawerTheme: NavigationDrawerThemeData(
              indicatorColor: lightColorScheme.primary),
          fontFamily: "Google Sans"),
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        'splash-screen': (context) => const SplashScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        'home-screen': (context) => const HomeScreen(),
      },
    );
  }
}
