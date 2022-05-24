import 'dart:convert';
import 'dart:io';
import 'package:dash_playground/home_screen.dart';
import 'package:http/http.dart' as http;

import 'package:dash_playground/providers/splash_screen_provider.dart';
import 'package:dash_playground/utils/animated_progress_bar.dart';
import 'package:dash_playground/utils/modifiers.dart';
import 'package:dash_playground/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SplashScreenProvider(),
      child: DashPlaygroundApp(),
    ),
  );
}

class DashPlaygroundApp extends StatefulWidget {
  const DashPlaygroundApp({Key? key}) : super(key: key);

  @override
  State<DashPlaygroundApp> createState() => _DashPlaygroundAppState();
}

class _DashPlaygroundAppState extends State<DashPlaygroundApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashPlayground(),
      initialRoute: 'splash-screen',
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
  State<DashPlayground> createState() => _DashPlaygroundState();
}

class _DashPlaygroundState extends State<DashPlayground> {
  Map<String, String> urls = {};

  var isLoaded = false;
  fetchURLS(context) async {
    var provider = Provider.of<SplashScreenProvider>(context, listen: false);
    var jsonUrl =
        "https://raw.githubusercontent.com/ManasMalla/Dash-s-Playground/main/urls.json";
    var jsonUri = Uri.tryParse(jsonUrl);
    if (jsonUri == null) {
      return;
    }
    final response = await http.get(jsonUri);
    if (response.statusCode == 200) {
      provider.updatePercentage(0.1);
      List<dynamic> values = json.decode(response.body)['urls'];
      var platform = Platform.isMacOS
          ? "macOS"
          : Platform.isWindows
              ? "windows"
              : Platform.isLinux
                  ? "linux"
                  : "";
      if (Platform.isMacOS) {
        Process.run('uname', ['-m']).then((result) {
          if (result.stdout != "x86_64") {
            platform = "macOS-silicon";
          }
        });
      }
      var androidStudioURls = values
          .where((element) => element["name"] == "android-studio")
          .toList();
      var androidStudioURL = (androidStudioURls[0]["urls"] as List<dynamic>)
          .where((element) => element["platform"] == platform)
          .toList();
      print("Android Studio ($platform): ${androidStudioURL[0]["url"]}");
      urls["Android Studio"] = androidStudioURL[0]["url"];
      provider.updatePercentage(0.25);
      var cmdLineToolsURls = values
          .where((element) => element["name"] == "cmdline-tools")
          .toList();
      var cmdLineToolsURL = (cmdLineToolsURls[0]["urls"] as List<dynamic>)
          .where((element) => element["platform"] == platform)
          .toList();
      print("Command Line Tools ($platform): ${cmdLineToolsURL[0]["url"]}");
      urls["Command Line Tools"] = cmdLineToolsURL[0]["url"];
      provider.updatePercentage(0.4);
      var openJDKURls =
          values.where((element) => element["name"] == "openJDK").toList();
      var openJDKURL = (openJDKURls[0]["urls"] as List<dynamic>)
          .where((element) => element["platform"] == platform)
          .toList();
      print("OpenJDK ($platform): ${openJDKURL[0]["url"]}");
      urls["OpenJDK"] = openJDKURL[0]["url"];
      provider.updatePercentage(0.6);
      var visualStudioCodeURLS = values
          .where((element) => element["name"] == "visual-studio-code")
          .toList();
      var visualStudioCodeUrl =
          (visualStudioCodeURLS[0]["urls"] as List<dynamic>)
              .where((element) => element["platform"] == platform)
              .toList();
      print("Visual Studio Code ($platform): ${visualStudioCodeUrl[0]["url"]}");
      urls["Visual Studio Code"] = visualStudioCodeUrl[0]["url"];
      provider.updatePercentage(0.8);
      //add sdk urls and install sdk

      Future.delayed(const Duration(seconds: 1), () {
        provider.updatePercentage(1.0);
        Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
          isLoaded = true;
          setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (urls.isEmpty) {
      fetchURLS(context);
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
                              color: Color(0xFF54c5f8),
                            ),
                          ),
                          Text(
                            ' PLAYGROUND',
                            style: TextStyle(
                              fontFamily: 'Childish Reverie',
                              fontSize: getProportionateHeight(48),
                              color: Color(0xFF01579b),
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
              duration: Duration(seconds: 1),
              child: AnimatedProgressBar(
                width: 0.6,
                duration:
                    Platform.isMacOS || Platform.isLinux || Platform.isWindows
                        ? Duration(seconds: 1)
                        : Duration(seconds: 2),
              ),
            ),
            Spacer(),
            AnimatedOpacity(
              opacity: isLoaded ? 1 : 0,
              duration: Duration(seconds: 1),
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
