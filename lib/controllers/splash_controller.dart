import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dash_playground/providers/installation_provider.dart';
import 'package:dash_playground/providers/splash_screen_provider.dart';
import 'package:dash_playground/utils/platform_extension.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

enum ResponseStatus { success, failure }

class SplashController extends ControllerMVC {
  ///Fetches the JSON of URLs from Github and stores the result in [provider] and updates the progress with [uiProvider]
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
        uiProvider.updateNetworkAvailability();
        Map<String, dynamic> decodedJson = jsonDecode(response.body);

        Map<int, int> emulatorSizesList = {
          for (var e in decodedJson['emulator-size'] as List<dynamic>)
            int.tryParse(((e as Map<String, dynamic>).entries.first.key)) ?? 33:
                (int.tryParse((e).entries.first.value) ?? 1400)
        };

        getFlutterSpecificPlatform().then((platform) {
          //Fetch the URLs for the specific platform
          List<Map<String, String>> platformSpecificJson =
              (decodedJson[platform] as List<dynamic>)
                  .map((e) => (e as Map<String, dynamic>)
                      .map((key, value) => MapEntry(key, value.toString())))
                  .toList();
          fetchURLs(platformSpecificJson, emulatorSizesList, platform, provider,
                  uiProvider)
              .then((value) => {
                    if (value == ResponseStatus.success) {onCompletedCallback()}
                  });
        });
      } else {
        //Fetch Data from local JSON when the fetching of data from GitHub fails
        fetchDummyURLS(uiProvider, provider).then((value) => {
              if (value == ResponseStatus.success) {onCompletedCallback()}
            });
      }
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      //Fetch the data from local JSON when time out failure occurrs or GitHub failing to provide the JSON due to network

      fetchDummyURLS(uiProvider, provider).then((value) => {
            if (value == ResponseStatus.success) {onCompletedCallback()}
          });
    });
  }

  Future<ResponseStatus> fetchURLs(
      List<Map<String, String>> platformJson,
      Map<int, int> systemImageSizes,
      String platform,
      InstallationProvider provider,
      SplashScreenProvider uiProvider) async {
    //Fetching and setting up the Android Studio URL, size and config
    var androidStudioConfig = platformJson
        .where(
            (element) => element["name"]?.contains("android-studio") ?? false)
        .toList()
        .first;
    provider.urls["Android Studio"] = androidStudioConfig["url"] ?? "";

    provider.setAndroidStudioCodename(androidStudioConfig["name"]
        .toString()
        .split("android-studio-")
        .last
        .capitalize());
    provider.sizes["Android Studio"] = int.tryParse(
            androidStudioConfig["size"].toString().replaceAll(" MiB", "")) ??
        0;
    uiProvider.updatePercentage(0.25);

    // Setting up the URL and config for Android Command Line tools

    var cmdLineToolsConfig = platformJson
        .where((element) => element["name"]?.contains("cmdline-tools") ?? false)
        .toList()
        .first;
    provider.urls["Command Line Tools"] = cmdLineToolsConfig["url"] ?? "";
    provider.sizes["Command Line Tools"] = int.tryParse(
            cmdLineToolsConfig["size"].toString().replaceAll(" MiB", "")) ??
        0;
    uiProvider.updatePercentage(0.4);

    // Setting up the URL and config for OpenJDK

    var openJDKConfig = platformJson
        .where((element) => element["name"]?.contains("openJDK") ?? false)
        .toList()
        .first;
    provider.urls["OpenJDK"] = openJDKConfig["url"] ?? "";
    provider.sizes["OpenJDK"] =
        int.tryParse(openJDKConfig["size"].toString().replaceAll(" MiB", "")) ??
            0;
    uiProvider.updatePercentage(0.6);

    // Setting up the URL and Config for Visual Studio Code

    var visualStudioCodeConfig = platformJson
        .where((element) =>
            element["name"]?.contains("visual-studio-code") ?? false)
        .toList()
        .first;
    provider.urls["Visual Studio Code"] = visualStudioCodeConfig["url"] ?? "";
    provider.sizes["Visual Studio Code"] = int.tryParse(
            visualStudioCodeConfig["size"].toString().replaceAll(" MiB", "")) ??
        0;
    uiProvider.updatePercentage(0.8);

    // Setting up the URL and config for Flutter SDK

    var flutterSDKConfig = platformJson
        .where((element) => element["name"]?.contains("flutter-sdk") ?? false)
        .toList()
        .first;

    var flutterSDKURLs = await getFlutterUrl(platform);
    if (flutterSDKURLs == null) {
      return ResponseStatus.failure;
    }
    provider.urls['Flutter SDK (beta)'] = flutterSDKURLs[1];
    provider.urls['Flutter SDK (master)'] = flutterSDKURLs[2];
    provider.urls['Flutter SDK (stable)'] = flutterSDKURLs[0];
    provider.sizes['Flutter SDK'] = int.tryParse(
            flutterSDKConfig['size'].toString().replaceAll(" MiB", "")) ??
        0;

    // Setting up the URL and config for Desktop tools (Visual Studio, Xcode, or Clang)

    var desktopToolConfig = platformJson
        .where((element) => element["name"]?.contains("desktop-tools") ?? false)
        .toList()
        .first;
    provider.sizes['desktop-tools'] = int.tryParse(
            desktopToolConfig['size'].toString().replaceAll(" MiB", "")) ??
        0;

    // Setting up the URL and config for System Images

    for (var systemImage in systemImageSizes.entries) {
      provider.sizes['systemImageSDK${systemImage.key}'] = systemImage.value;
    }
    uiProvider.updatePercentage(1.0);

    await Future.delayed(const Duration(seconds: 1), () {
      provider.urls.entries
          .map((e) => "${e.key} ($platform): ${e.value}")
          .forEach((element) {
        log(element);
      });
    });

    return ResponseStatus.success;
  }

  Future<List<String>?> getFlutterUrl(String platform) async {
    var flutterSDKURL =
        'https://storage.googleapis.com/flutter_infra_release/releases/releases_${Platform.isMacOS ? "macos" : Platform.isWindows ? "windows" : "linux"}.json';
    var flutterSDKURI = Uri.tryParse(flutterSDKURL);
    if (flutterSDKURI == null) {
      return null;
    }
    var response = await get(flutterSDKURI);

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
      return [stableURL, betaURL, masterURL];
    } else {
      return null;
    }
  }

  Future<String> getFlutterSpecificPlatform() async {
    String tempPlatform = Platform.isMacOS
        ? "macOS"
        : Platform.isWindows
            ? "windows"
            : Platform.isLinux
                ? "linux"
                : "";
    if (Platform.isMacOS) {
      try {
        var result = await Process.run('uname', ['-m']);
        if (!(result.stdout as String).contains("x86_64") &&
            result.stdout != "") {
          tempPlatform = "macOS-silicon";
        }
        return tempPlatform;
      } catch (e) {
        return tempPlatform;
      }
    } else {
      return tempPlatform;
    }
  }

  Future<ResponseStatus> fetchDummyURLS(
      SplashScreenProvider uiProvider, InstallationProvider provider) async {
    var jsonString =
        "{\"macOS\":[{\"name\":\"android-studio-chipmunk\",\"url\":\"https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2021.2.1.15/android-studio-2021.2.1.15-mac.zip\",\"size\":\"1017MiB\"},{\"name\":\"cmdline-tools\",\"url\":\"https://dl.google.com/android/repository/commandlinetools-mac-8512546_latest.zip\",\"size\":\"108MiB\"},{\"name\":\"openJDK\",\"url\":\"https://download.java.net/java/GA/jdk18.0.1.1/65ae32619e2f40f3a9af3af1851d6e19/2/GPL/openjdk-18.0.1.1_macos-x64_bin.tar.gz\",\"size\":\"177MiB\"},{\"name\":\"visual-studio-code\",\"url\":\"https://code.visualstudio.com/sha/download?build=stable&os=darwin\",\"size\":\"104MiB\"},{\"name\":\"desktop-tools\",\"platform\":\"macOS\",\"size\":\"12600MiB\"},{\"name\":\"flutter-sdk\",\"platform\":\"macOS\",\"size\":\"1200MiB\"}],\"macOS-Silicon\":[{\"name\":\"android-studio-chipmunk\",\"url\":\"https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2021.2.1.15/android-studio-2021.2.1.15-mac_arm.zip\",\"size\":\"1014MiB\"},{\"name\":\"cmdline-tools\",\"url\":\"https://dl.google.com/android/repository/commandlinetools-mac-8512546_latest.zip\",\"size\":\"108MiB\"},{\"name\":\"openJDK\",\"url\":\"https://download.java.net/java/GA/jdk18.0.1.1/65ae32619e2f40f3a9af3af1851d6e19/2/GPL/openjdk-18.0.1.1_macos-aarch64_bin.tar.gz\",\"size\":\"175MiB\"},{\"name\":\"visual-studio-code\",\"url\":\"https://code.visualstudio.com/sha/download?build=stable&os=darwin-arm64\",\"size\":\"103MiB\"},{\"name\":\"desktop-tools\",\"platform\":\"macOS-silicon\",\"size\":\"12600MiB\"},{\"name\":\"flutter-sdk\",\"platform\":\"macOS-silicon\",\"size\":\"1200MiB\"}],\"windows\":[{\"name\":\"android-studio-chipmunk\",\"url\":\"https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2021.2.1.15/android-studio-2021.2.1.15-windows.zip\",\"size\":\"940MiB\"},{\"name\":\"cmdline-tools\",\"url\":\"https://dl.google.com/android/repository/commandlinetools-win-8512546_latest.zip\",\"size\":\"108MiB\"},{\"name\":\"openJDK\",\"url\":\"https://download.java.net/java/GA/jdk18.0.1.1/65ae32619e2f40f3a9af3af1851d6e19/2/GPL/openjdk-18.0.1.1_windows-x64_bin.zip\",\"size\":\"179MiB\"},{\"name\":\"visual-studio-code\",\"url\":\"https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive\",\"size\":\"104MiB\"},{\"name\":\"desktop-tools\",\"platform\":\"windows\",\"size\":\"6370MiB\"},{\"name\":\"flutter-sdk\",\"platform\":\"windows\",\"size\":\"896MiB\"}],\"linux\":[{\"name\":\"android-studio-chipmunk\",\"url\":\"https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2021.2.1.15/android-studio-2021.2.1.15-linux.tar.gz\",\"size\":\"964MiB\"},{\"name\":\"cmdline-tools\",\"url\":\"https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip\",\"size\":\"108MiB\"},{\"name\":\"openJDK\",\"url\":\"https://download.java.net/java/GA/jdk18.0.1.1/65ae32619e2f40f3a9af3af1851d6e19/2/GPL/openjdk-18.0.1.1_linux-x64_bin.tar.gz\",\"size\":\"180MiB\"},{\"name\":\"visual-studio-code\",\"url\":\"https://code.visualstudio.com/sha/download?build=stable&os=linux-x64\",\"size\":\"110MiB\"},{\"name\":\"desktop-tools\",\"platform\":\"linux\",\"size\":\"500MiB\"},{\"name\":\"flutter-sdk\",\"platform\":\"linux\",\"size\":\"598MiB\"}],\"emulator-size\":[{\"33\":\"1400\"},{\"32\":\"1200\"},{\"31\":\"627\"},{\"30\":\"645\"},{\"29\":\"658\"},{\"28\":\"539\"},{\"0\":\"340\"}]}";
    uiProvider.updatePercentage(0.1);
    Map<String, dynamic> decodedJson = jsonDecode(jsonString);

    Map<int, int> emulatorSizesList = {
      for (var e in decodedJson['emulator-size'] as List<dynamic>)
        int.tryParse(((e as Map<String, dynamic>).entries.first.key)) ?? 33:
            (int.tryParse((e).entries.first.value) ?? 1400)
    };

    var platform = await getFlutterSpecificPlatform();
    //Fetch the URLs for the specific platform
    List<Map<String, String>> platformSpecificJson =
        (decodedJson[platform] as List<dynamic>)
            .map((e) => (e as Map<String, dynamic>)
                .map((key, value) => MapEntry(key, value.toString())))
            .toList();
    return fetchURLs(platformSpecificJson, emulatorSizesList, platform,
        provider, uiProvider);
  }
}
