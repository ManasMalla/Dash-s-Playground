import 'dart:convert';
import 'dart:io';

import 'package:dash_playground/providers/installation_provider.dart';
import 'package:dash_playground/providers/splash_screen_provider.dart';
import 'package:dash_playground/utils/platform_extension.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class SplashController extends ControllerMVC {
  void fetchJSON(SplashScreenProvider uiProvider, InstallationProvider provider,
      Function() onCompletedCallback) {
    var jsonUrl =
        "https://raw.githubusercontent.com/ManasMalla/Dash-s-Playground/main/urls.json";
    var jsonUri = Uri.tryParse(jsonUrl);
    if (jsonUri == null) {
      return;
    }
    get(jsonUri).then((Response response) {
      if (response.statusCode == 200) {
        uiProvider.updatePercentage(0.1);
        Map<String, List<Map<dynamic, dynamic>>> decodedJson =
            json.decode(response.body);

        Map<int, int> emulatorSizesList =
            (decodedJson['emulator-size'] as Map<int, int>?) ?? {33: 1400};
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
            fetchURL(
                decodedJson[platform] as List<Map<String, String>>,
                emulatorSizesList,
                platform,
                provider,
                uiProvider,
                onCompletedCallback);
          });
        } else {
          fetchURL(
              decodedJson[platform] as List<Map<String, String>>,
              emulatorSizesList,
              platform,
              provider,
              uiProvider,
              onCompletedCallback);
        }
      }
    });
  }

  void fetchURL(
      List<Map<String, String>> values,
      Map<int, int> systemImageSizes,
      String platform,
      InstallationProvider provider,
      SplashScreenProvider uiProvider,
      Function() onCompletedCallback) {
    var androidStudioURL = values
        .where(
            (element) => element["name"]?.contains("android-studio") ?? false)
        .toList()
        .first;
    provider.urls["Android Studio"] = androidStudioURL["url"] ?? "";

    provider.setAndroidStudioCodename(androidStudioURL["name"]
        .toString()
        .split("android-studio-")
        .last
        .capitalize());
    provider.sizes["Android Studio"] = int.tryParse(
            androidStudioURL["size"].toString().replaceAll(" MiB", "")) ??
        0;
    uiProvider.updatePercentage(0.25);

    var cmdLineToolsURL = values
        .where((element) => element["name"]?.contains("cmdline-tools") ?? false)
        .toList()
        .first;
    provider.urls["Command Line Tools"] = cmdLineToolsURL["url"] ?? "";
    provider.sizes["Command Line Tools"] = int.tryParse(
            cmdLineToolsURL["size"].toString().replaceAll(" MiB", "")) ??
        0;
    uiProvider.updatePercentage(0.4);

    var openJDKURL = values
        .where((element) => element["name"]?.contains("openJDK") ?? false)
        .toList()
        .first;
    provider.urls["OpenJDK"] = openJDKURL["url"] ?? "";
    provider.sizes["OpenJDK"] =
        int.tryParse(openJDKURL["size"].toString().replaceAll(" MiB", "")) ?? 0;
    uiProvider.updatePercentage(0.6);

    var visualStudioCodeURL = values
        .where((element) =>
            element["name"]?.contains("visual-studio-code") ?? false)
        .toList()
        .first;
    provider.urls["Visual Studio Code"] = visualStudioCodeURL["url"] ?? "";
    provider.sizes["Visual Studio Code"] = int.tryParse(
            visualStudioCodeURL["size"].toString().replaceAll(" MiB", "")) ??
        0;
    uiProvider.updatePercentage(0.8);

    var flutterSDKSize = values
        .where((element) => element["name"]?.contains("flutter-sdk") ?? false)
        .toList()
        .first;
    provider.sizes['Flutter SDK'] = int.tryParse(
            flutterSDKSize['size'].toString().replaceAll(" MiB", "")) ??
        0;
    var desktopToolSize = values
        .where((element) => element["name"]?.contains("desktop-tools") ?? false)
        .toList()
        .first;
    provider.sizes['desktop-tools'] = int.tryParse(
            desktopToolSize['size'].toString().replaceAll(" MiB", "")) ??
        0;
    for (var systemImage in systemImageSizes.entries) {
      provider.sizes['systemImageSDK${systemImage.key}'] = systemImage.value;
    }
    getFlutterUrl(platform, provider, uiProvider, onCompletedCallback);
  }

  void getFlutterUrl(String platform, InstallationProvider provider,
      SplashScreenProvider uiProvider, Function() onCompletedCallback) {
    var flutterSDKURL =
        'https://storage.googleapis.com/flutter_infra_release/releases/releases_${Platform.isMacOS ? "macos" : Platform.isWindows ? "windows" : "linux"}.json';
    var flutterSDKURI = Uri.tryParse(flutterSDKURL);
    if (flutterSDKURI == null) {
      return;
    }
    get(flutterSDKURI).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var baseURL = jsonResponse["base_url"];
        List<dynamic> urls = jsonResponse["releases"];
        var stableURLS = urls
            .where((element) =>
                element["channel"] == "stable" &&
                element["dart_sdk_arch"] ==
                    (platform == "macOS-silicon" ? "arm64" : "x64"))
            .toList()
            .reduce((value, element) => (DateFormat("yyyy-MM-ddThh:mm:ss.SSSZ")
                        .parse(value["release_date"]))
                    .isAfter(DateFormat("yyyy-MM-ddThh:mm:ss.SSSZ")
                        .parse(element["release_date"]))
                ? value
                : element);
        var stableURL = "$baseURL/${stableURLS["archive"]}";
        var betaURLS = urls
            .where((element) =>
                element["channel"] == "beta" &&
                element["dart_sdk_arch"] ==
                    (platform == "macOS-silicon" ? "arm64" : "x64"))
            .toList()
            .reduce((value, element) => (DateFormat("yyyy-MM-ddThh:mm:ss.SSSZ")
                        .parse(value["release_date"]))
                    .isAfter(DateFormat("yyyy-MM-ddThh:mm:ss.SSSZ")
                        .parse(element["release_date"]))
                ? value
                : element);
        var betaURL = "$baseURL/${betaURLS["archive"]}";
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
          //todo add here
          onCompletedCallback();
        });
      } else {
        return;
      }
    });
  }
}
