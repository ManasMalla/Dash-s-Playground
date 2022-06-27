import 'dart:convert';
import 'dart:io';
import 'package:dash_playground/controllers/splash_controller.dart';
import 'package:dash_playground/home_screen.dart';
import 'package:dash_playground/providers/installation_provider.dart';
import 'package:dash_playground/utils/platform_extension.dart';
import 'package:dash_playground/providers/theme_provider.dart';
import 'package:http/http.dart' as http;

import 'package:dash_playground/providers/splash_screen_provider.dart';
import 'package:dash_playground/utils/animated_progress_bar.dart';
import 'package:dash_playground/utils/modifiers.dart';
import 'package:dash_playground/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
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

class DashPlayground extends StatefulWidget {
  const DashPlayground({Key? key}) : super(key: key);

  @override
  StateMVC<DashPlayground> createState() => _DashPlaygroundState();
}

class _DashPlaygroundState extends StateMVC<DashPlayground> {
  var isLoaded = false;
  late InstallationProvider provider;
  late SplashScreenProvider uiProvider;

  late SplashController splashController;

  _DashPlaygroundState() : super(SplashController()) {
    /// Acquire a reference to the passed Controller.
    splashController = controller as SplashController;
  }

  @override
  void initState() {
    super.initState();
    provider = Provider.of<InstallationProvider>(context, listen: false);

    uiProvider = Provider.of<SplashScreenProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (provider.urls.isEmpty &&
        platformCategory() != PlatformCategory.mobile) {
      splashController.fetchJSON(uiProvider, provider, () {
        Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
          isLoaded = true;
          setState(() {});
        });
      });
    } else if (platformCategory() == PlatformCategory.mobile) {
      uiProvider.updatePercentage(1.0);
      Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
        isLoaded = true;
        setState(() {});
      });
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/splash_screen.png'),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            SizedBox(
              height: getProportionateHeight(32),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/title_ribbon.png',
                  width: Modifier.fillMaxHeight(0.8),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: getProportionateHeight(12),
                    ),
                    SizedBox(
                      height: getProportionateHeight(36),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'DASH\'S ',
                            style: TextStyle(
                              fontFamily: 'Childish Reverie',
                              fontSize: getProportionateHeight(48),
                              color: const Color(0xFF54c5f8),
                            ),
                          ),
                          Text(
                            ' PLAYGROUND',
                            style: TextStyle(
                              fontFamily: 'Childish Reverie',
                              fontSize: getProportionateHeight(48),
                              color: const Color(0xFF01579b),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: getProportionateHeight(8),
            ),
            AnimatedOpacity(
              opacity: isLoaded ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: AnimatedProgressBar(
                width: 0.6,
                duration:
                    Platform.isMacOS || Platform.isLinux || Platform.isWindows
                        ? const Duration(seconds: 1)
                        : const Duration(seconds: 2),
              ),
            ),
            const Spacer(),
            AnimatedOpacity(
              opacity: isLoaded ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Align(
                alignment: Alignment.bottomRight,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed('home-screen');
                  },
                  elevation: 0,
                  height: getProportionateHeight(64),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: getProportionateHeight(20),
                  ),
                  color: Colors.amber,
                  shape: const CircleBorder(),
                ),
              ),
            ),
            SizedBox(
              height: getProportionateHeight(16),
            )
          ],
        ),
      ),
    );
  }
}
