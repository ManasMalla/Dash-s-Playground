import 'dart:convert';
import 'dart:io';

import 'package:dash_playground/providers/installation_provider.dart';
import 'package:dash_playground/utils/platform_extension.dart';
import 'package:http/http.dart';

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

class FlutterDependency extends Dependency {
  final FlutterChannel channel;

  FlutterDependency({
    required this.channel,
    required super.name,
    super.url,
    required super.size,
    super.version,
    super.description,
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

    final flutterDependencies = await getFlutterUrl(platform);

    return [
      ...flutterDependencies,
      androidStudioDependency,
      cmdLineToolsDependency,
      openJDKDependency,
      visualStudioCodeDependency,
      desktopToolDependency,
      ...systemImageDependencies,
    ];
  }

  static FlutterDependency _getFlutterSDKDependency(List<dynamic> urls,
      String hash, String platform, String baseUrl, FlutterChannel channel) {
    final entry = urls
        .where((element) =>
            element["hash"] == hash &&
            element["dart_sdk_arch"] ==
                (platform == "macOS-silicon" ? "arm64" : "x64"))
        .toList()
        .first;
    return FlutterDependency(
        name: "Flutter SDK",
        size: 1200,
        description: "Flutter SDK",
        url: "$baseUrl/${entry["archive"]}",
        version: entry["version"],
        channel: channel);
  }

  static Future<List<FlutterDependency>> getFlutterUrl(String platform) async {
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
      Map<String, dynamic> currentReleases =
          Map.from(jsonResponse["current_release"]);
      String stableHash = currentReleases["stable"];
      String betaHash = currentReleases["beta"];
      String devHash = currentReleases["dev"];
      List<dynamic> urls = jsonResponse["releases"];
      var stableSDK = _getFlutterSDKDependency(
          urls, stableHash, platform, baseURL, FlutterChannel.stable);
      var betaSDK = _getFlutterSDKDependency(
          urls, betaHash, platform, baseURL, FlutterChannel.beta);
      // var devSDK = _getFlutterSDKDependency(
      //     urls, devHash, platform, baseURL, FlutterChannel.dev);
      var masterSDK = FlutterDependency(
          channel: FlutterChannel.master,
          name: "Flutter SDK",
          size: 1200,
          url:
              "https://github.com/flutter/flutter/archive/refs/heads/master.zip",
          version: "master",
          description: "Flutter SDK");
      return [stableSDK, betaSDK, masterSDK];
    } else {
      throw Exception("Failed to load JSON");
    }
  }
}
