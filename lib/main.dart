import 'dart:convert';
import 'dart:io';
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashPlayground(),
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
      var openJDKURls =
          values.where((element) => element["name"] == "openJDK").toList();
      var openJDKURL = (androidStudioURls[0]["urls"] as List<dynamic>)
          .where((element) => element["platform"] == platform)
          .toList();
      print("OpenJDK ($platform): ${openJDKURL[0]["url"]}");
      urls["OpenJDK"] = openJDKURL[0]["url"];
      provider.updatePercentage(0.25);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    fetchURLS(context);
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: getProportionateHeight(12),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'D',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: getProportionateHeight(32),
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF54c5f8),
                          ),
                        ),
                        Text(
                          'ASH\'S ',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: getProportionateHeight(20),
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF54c5f8),
                          ),
                        ),
                        Text(
                          'P',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: getProportionateHeight(32),
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF01579b),
                          ),
                        ),
                        Text(
                          'LAYGROUND',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: getProportionateHeight(20),
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF01579b),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: getProportionateHeight(8),
            ),
            AnimatedProgressBar(
              width: 0.6,
              duration:
                  Platform.isMacOS || Platform.isLinux || Platform.isWindows
                      ? Duration(seconds: 1)
                      : Duration(seconds: 2),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: MaterialButton(
                onPressed: () {},
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
            SizedBox(
              height: getProportionateHeight(16),
            )
          ],
        ),
      ),
    );
  }
}
