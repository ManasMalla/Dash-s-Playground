
import 'package:dash_playground/main.dart';
import 'package:dash_playground/ui/SplashScreen.dart';
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
  void initState() {
    // connect();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setPrefThemeMode(context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setPrefThemeMode(context);
    super.didChangePlatformBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DashPlayground(),
      initialRoute: 'splash-screen',
      theme: ThemeData.fallback().copyWith(
        useMaterial3: true,
      ),
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        'splash-screen': (context) => const DashPlayground(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        'home-screen': (context) => const HomeScreen(),
      },
    );
  }
}