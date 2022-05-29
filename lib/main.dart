import 'dart:convert';
import 'dart:io';
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
import 'package:intl/intl.dart';
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
  State<DashPlayground> createState() => _DashPlaygroundState();
}

class _DashPlaygroundState extends State<DashPlayground> {
  var isLoaded = false;
  late InstallationProvider provider;
  late SplashScreenProvider uiProvider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<InstallationProvider>(context, listen: false);

    uiProvider = Provider.of<SplashScreenProvider>(context, listen: false);
  }

  fetchJSON(context) async {
    var jsonUrl =
        "https://raw.githubusercontent.com/ManasMalla/Dash-s-Playground/main/urls.json";
    var jsonUri = Uri.tryParse(jsonUrl);
    if (jsonUri == null) {
      return;
    }
    final response = await http.get(jsonUri);
    if (response.statusCode == 200) {
      uiProvider.updatePercentage(0.1);
      List<dynamic> values = json.decode(response.body)['urls'];
      List<dynamic> desktopSizesList =
          json.decode(response.body)['desktop-tools'];
      List<dynamic> flutterSDKSizesList =
          json.decode(response.body)['flutter-sdk'];
      List<dynamic> emulatorSizesList =
          json.decode(response.body)['emulator-size'];
      var platform = Platform.isMacOS
          ? "macOS"
          : Platform.isWindows
              ? "windows"
              : Platform.isLinux
                  ? "linux"
                  : "";
      if (Platform.isMacOS) {
        Process.run('uname', ['-m']).then((result) {
          if (!(result.stdout as String).contains("x86_64") &&
              result.stdout != "") {
            platform = "macOS-silicon";
          }
          fetchPlatformSpecificURL(platform, values, flutterSDKSizesList,
              desktopSizesList, emulatorSizesList);
        });
      } else {
        fetchPlatformSpecificURL(platform, values, flutterSDKSizesList,
            desktopSizesList, emulatorSizesList);
      }
    }
  }

  fetchPlatformSpecificURL(platform, values, List<dynamic> flutterSDKSizes,
      List<dynamic> desktopToolsSizes, List<dynamic> systemImageSizes) {
    var androidStudioURls = values
        .where(
            (element) => element["name"].toString().contains("android-studio"))
        .toList();
    var androidStudioURL = (androidStudioURls[0]["urls"] as List<dynamic>)
        .where((element) => element["platform"] == platform)
        .toList();
    provider.urls["Android Studio"] = androidStudioURL[0]["url"];

    provider.setAndroidStudioCodename(androidStudioURls[0]["name"]
        .toString()
        .split("android-studio-")
        .last
        .capitalize());
    provider.sizes["Android Studio"] = int.tryParse(
            androidStudioURL[0]["size"].toString().replaceAll(" MiB", "")) ??
        0;
    uiProvider.updatePercentage(0.25);

    var cmdLineToolsURls =
        values.where((element) => element["name"] == "cmdline-tools").toList();
    var cmdLineToolsURL = (cmdLineToolsURls[0]["urls"] as List<dynamic>)
        .where((element) => element["platform"] == platform)
        .toList();
    provider.urls["Command Line Tools"] = cmdLineToolsURL[0]["url"];
    provider.sizes["Command Line Tools"] = int.tryParse(
            cmdLineToolsURL[0]["size"].toString().replaceAll(" MiB", "")) ??
        0;
    uiProvider.updatePercentage(0.4);

    var openJDKURls =
        values.where((element) => element["name"] == "openJDK").toList();
    var openJDKURL = (openJDKURls[0]["urls"] as List<dynamic>)
        .where((element) => element["platform"] == platform)
        .toList();
    provider.urls["OpenJDK"] = openJDKURL[0]["url"];
    provider.sizes["OpenJDK"] =
        int.tryParse(openJDKURL[0]["size"].toString().replaceAll(" MiB", "")) ??
            0;
    uiProvider.updatePercentage(0.6);

    var visualStudioCodeURLS = values
        .where((element) => element["name"] == "visual-studio-code")
        .toList();
    var visualStudioCodeUrl = (visualStudioCodeURLS[0]["urls"] as List<dynamic>)
        .where((element) => element["platform"] == platform)
        .toList();
    provider.urls["Visual Studio Code"] = visualStudioCodeUrl[0]["url"];
    provider.sizes["Visual Studio Code"] = int.tryParse(
            visualStudioCodeUrl[0]["size"].toString().replaceAll(" MiB", "")) ??
        0;
    uiProvider.updatePercentage(0.8);

    provider.sizes['Flutter SDK'] = int.tryParse(flutterSDKSizes
            .firstWhere((element) => element["platform"] == platform)['size']
            .toString()
            .replaceAll(" MiB", "")) ??
        0;
    provider.sizes['desktop-tools'] = int.tryParse(desktopToolsSizes
            .firstWhere((element) => element["platform"] == platform)['size']
            .toString()
            .replaceAll(" MiB", "")) ??
        0;
    for (var element in systemImageSizes) {
      provider.sizes[
              'systemImageSDK${(element as Map<String, dynamic>).entries.first.key}'] =
          int.tryParse(element.entries.first.value) ?? 0;
    }
    var flutterSDKURL =
        'https://storage.googleapis.com/flutter_infra_release/releases/releases_${Platform.isMacOS ? "macos" : Platform.isWindows ? "windows" : "linux"}.json';
    var flutterSDKURI = Uri.tryParse(flutterSDKURL);
    if (flutterSDKURI == null) {
      return;
    }
    http.get(flutterSDKURI).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var baseURL = jsonResponse["base_url"];
        List<dynamic> urls = jsonResponse["releases"];
        var stableURLS = urls
            .where((element) =>
                element["channel"] == "stable" &&
                element["dart_sdk_arch"] ==
                    (platform == "macOS-silicon" ? "arm64" : "x64"))
            .toList();
        //get the latest
        var stableURLMap = stableURLS.reduce((value, element) =>
            (DateFormat("yyyy-MM-ddThh:mm:ss.SSSZ")
                        .parse(value["release_date"]))
                    .isAfter(DateFormat("yyyy-MM-ddThh:mm:ss.SSSZ")
                        .parse(element["release_date"]))
                ? value
                : element);
        var stableURL = "$baseURL/${stableURLMap["archive"]}";
        var betaURLS = urls
            .where((element) =>
                element["channel"] == "beta" &&
                element["dart_sdk_arch"] ==
                    (platform == "macOS-silicon" ? "arm64" : "x64"))
            .toList();
        var betaURLMap = betaURLS.reduce((value, element) =>
            (DateFormat("yyyy-MM-ddThh:mm:ss.SSSZ")
                        .parse(value["release_date"]))
                    .isAfter(DateFormat("yyyy-MM-ddThh:mm:ss.SSSZ")
                        .parse(element["release_date"]))
                ? value
                : element);
        var betaURL = "$baseURL/${betaURLMap["archive"]}";
        var masterURL =
            "https://github.com/flutter/flutter/archive/refs/heads/master.zip";
        provider.urls['Flutter SDK (beta)'] = betaURL;
        provider.urls['Flutter SDK (master)'] = masterURL;
        provider.urls['Flutter SDK (stable)'] = stableURL;
        uiProvider.updatePercentage(1.0);

        Future.delayed(const Duration(seconds: 1), () {
          provider.urls.entries
              .map((e) => "${e.key} ($platform): ${e.value}")
              .forEach((element) {
            print(element);
          });
          // provider.sizes.entries
          //     .map((e) => "${e.key} ($platform): ${e.value}")
          //     .forEach((element) {
          //   print(element);
          // });

          Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
            isLoaded = true;
            setState(() {});
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (provider.urls.isEmpty &&
        platformCategory() != PlatformCategory.mobile) {
      fetchJSON(context);
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
