import 'dart:convert';
import 'dart:io';

import 'package:dash_playground/providers/installation_provider.dart';
import 'package:dash_playground/utils/platform_extension.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class Dependency {
  final String name;
  final String? url;
  final int size;
  final String? version;
  final String? description;

  Dependency({
    required this.name,
    this.url,
    required this.size,
    this.version,
    this.description,
  });
}

class DependencyWithInstallChoice {
  final Dependency dependency;
  bool isSelected;
  bool isInstalling;
  bool isInstalled;
  bool isDownloading;
  bool isExtracting;

  DependencyWithInstallChoice({
    required this.dependency,
    this.isSelected = false,
    this.isInstalling = false,
    this.isInstalled = false,
    this.isDownloading = false,
    this.isExtracting = false,
  });
}

class InitializationController {
  static Future<List<Dependency>> fetchJSON() async {
    var jsonUrl =
        "https://raw.githubusercontent.com/ManasMalla/Dash-s-Playground/main/urls.json";
    var jsonUri = Uri.tryParse(jsonUrl);
    if (jsonUri == null) {
      throw Exception("Invalid URL");
    }
    final response = await get(jsonUri);
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedJson = jsonDecode(response.body);
      Map<int, int> emulatorSizesList = {33: 1400};
      var platform = Platform.isMacOS
          ? "macOS"
          : Platform.isWindows
              ? "windows"
              : Platform.isLinux
                  ? "linux"
                  : "";
      if (Platform.isMacOS) {
        final result = await Process.run('uname', ['-m']);
        if (!(result.stdout as String).contains("x86_64") &&
            result.stdout != "") {
          platform = "macOS-Silicon";
        }
        return await fetchURL(
          decodedJson[platform],
          emulatorSizesList,
          platform,
        );
      } else {
        return await fetchURL(
            decodedJson[platform] as List<Map<String, String>>,
            emulatorSizesList,
            platform);
      }
    } else {
      throw Exception("Failed to load JSON");
    }
  }

  static Future<List<Dependency>> fetchURL(List<dynamic> values,
      Map<int, int> systemImageSizes, String platform) async {
    var androidStudioURL = values
        .where(
            (element) => element["name"]?.contains("android-studio") ?? false)
        .toList()
        .first;

    final androidStudioDependency = Dependency(
      name: "Android Studio",
      url: androidStudioURL["url"] ?? "",
      size: int.tryParse(
              androidStudioURL["size"].toString().replaceAll(" MiB", "")) ??
          0,
      version: androidStudioURL["name"]
          .toString()
          .split("android-studio-")
          .last
          .capitalize(),
    );

    var cmdLineToolsURL = values
        .where((element) => element["name"]?.contains("cmdline-tools") ?? false)
        .toList()
        .first;

    final cmdLineToolsDependency = Dependency(
      name: "Command Line Tools",
      url: cmdLineToolsURL["url"] ?? "",
      size: int.tryParse(
              cmdLineToolsURL["size"].toString().replaceAll(" MiB", "")) ??
          0,
    );

    var openJDKURL = values
        .where((element) => element["name"]?.contains("openJDK") ?? false)
        .toList()
        .first;
    final openJDKDependency = Dependency(
      name: "OpenJDK",
      url: openJDKURL["url"] ?? "",
      size:
          int.tryParse(openJDKURL["size"].toString().replaceAll(" MiB", "")) ??
              0,
    );

    var visualStudioCodeURL = values
        .where((element) =>
            element["name"]?.contains("visual-studio-code") ?? false)
        .toList()
        .first;
    final visualStudioCodeDependency = Dependency(
      name: "Visual Studio Code",
      url: visualStudioCodeURL["url"] ?? "",
      size: int.tryParse(
              visualStudioCodeURL["size"].toString().replaceAll(" MiB", "")) ??
          0,
    );

    var desktopToolSize = values
        .where((element) => element["name"]?.contains("desktop-tools") ?? false)
        .toList()
        .first;
    final desktopToolDependency = Dependency(
      name: "Desktop Tools",
      size: int.tryParse(
              desktopToolSize['size'].toString().replaceAll(" MiB", "")) ??
          0,
    );

    final systemImageDependencies = systemImageSizes.entries.map((systemImage) {
      final systemImageDependency = Dependency(
        name: "System Image SDK",
        version: systemImage.key.toString(),
        size: systemImage.value,
      );
      return systemImageDependency;
    }).toList();
    final flutterURLs = await getFlutterUrl(platform);

    var flutterSDKSize = values
        .where((element) => element["name"]?.contains("flutter-sdk") ?? false)
        .toList()
        .first;
    return [
      Dependency(
        name: "Flutter SDK",
        version: FlutterChannel.stable.name,
        url: flutterURLs[FlutterChannel.stable] ?? "",
        size: int.tryParse(
                flutterSDKSize['size'].toString().replaceAll(" MiB", "")) ??
            0,
      ),
      Dependency(
        name: "Flutter SDK",
        version: FlutterChannel.beta.name,
        url: flutterURLs[FlutterChannel.beta] ?? "",
        size: int.tryParse(
                flutterSDKSize['size'].toString().replaceAll(" MiB", "")) ??
            0,
      ),
      Dependency(
        name: "Flutter SDK",
        version: FlutterChannel.master.name,
        url: flutterURLs[FlutterChannel.master] ?? "",
        size: int.tryParse(
                flutterSDKSize['size'].toString().replaceAll(" MiB", "")) ??
            0,
      ),
      androidStudioDependency,
      cmdLineToolsDependency,
      openJDKDependency,
      visualStudioCodeDependency,
      desktopToolDependency,
      ...systemImageDependencies,
    ];
  }

  static Future<Map<FlutterChannel, String>> getFlutterUrl(
      String platform) async {
    var flutterSDKURL =
        'https://storage.googleapis.com/flutter_infra_release/releases/releases_${Platform.isMacOS ? "macos" : Platform.isWindows ? "windows" : "linux"}.json';
    var flutterSDKURI = Uri.tryParse(flutterSDKURL);
    if (flutterSDKURI == null) {
      throw Exception("Invalid URL");
    }
    final response = await get(flutterSDKURI);
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
      return {
        FlutterChannel.stable: stableURL,
        FlutterChannel.beta: betaURL,
        FlutterChannel.master: masterURL,
      };
    } else {
      throw Exception("Failed to load JSON");
    }
  }
}
