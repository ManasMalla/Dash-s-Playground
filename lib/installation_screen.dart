import 'dart:io';

import 'package:dash_playground/providers/installation_provider.dart';
import 'package:dash_playground/providers/theme_provider.dart';
import 'package:dash_playground/utils/modifiers.dart';
import 'package:dash_playground/utils/size_config.dart';
import 'package:dash_playground/utils/text_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class InstallationScreen extends StatefulWidget {
  const InstallationScreen({Key? key}) : super(key: key);

  @override
  State<InstallationScreen> createState() => _InstallationScreenState();
}

class _InstallationScreenState extends State<InstallationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late InstallationProvider provider;
  double downloadPercentage = 0.3;
  double numberOfDownloads = 5;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    provider = Provider.of<InstallationProvider>(context, listen: false);
    getTemporaryDirectory().then((temporaryDirectory) {
      //get url
      var forPlatform =
          'for ${Platform.isMacOS ? "Mac" : Platform.isWindows ? "Windows" : "Linux"}';
      var androidStudioVersion = "Chipmunk";

      var urls = {
        'Command Line Tools $forPlatform': provider.urls['Command Line Tools'],
        'Android Studio $androidStudioVersion | ${provider.urls['Android Studio']?.split("android-studio-").last.split("-").first.split(".").take(3).join(".")} $forPlatform':
            provider.urls['Android Studio'],
        'OpenJDK ${provider.urls['OpenJDK']?.split("openjdk-").last.split("_").first.split(".").take(3).join(".")} $forPlatform':
            provider.urls['OpenJDK'],
      };
      //Terminal/CMD/Shell - Flutter SDK, Android SDK Components, Android Emulator, Desktop Tools
      if (provider.useVisualStudioCodeAsIDE) {
        urls['Visual Studio Code $forPlatform'] =
            (provider.urls['Visual Studio Code']);
        numberOfDownloads++;
      }
      if (provider.deployEmulator) {
        numberOfDownloads++;
      }
      if (provider.supportDesktop) {
        numberOfDownloads++;
      }

      urls.forEach((key, value) {
        print(key);
      });

      // for (var entry in provider.urls.entries) {
      //   var name = entry.key;
      //   var url = entry.value;
      //   var formattedName = name == "Android Studio"
      //       ? "Android Studio"
      //       : name == "OpenJDK"
      //           ? "OpenJDK 18.0.1"
      //           : name == "Flutter SDK"
      //               ? "Flutter SDK 3.10.0"
      //               : name;

      // download the files
      //   Dio dio = Dio();
      //   dio.download(
      //     url,
      //     "${temporaryDirectory.path}/VSCode-darwin.zip",
      //     onReceiveProgress: (count, total) {
      //       var percentage = count * 100 / total;
      //       print(percentage);
      //     },
      //   );
      // }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: getProportionateHeight(36),
        ),
        TextWidget(
          "Android Studio is powerful!",
          size: getProportionateHeight(32),
          color: Colors.amberAccent.shade700,
          weight: FontWeight.bold,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextWidget(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit lorem ipsum.\nPraesent vehicula turpis augue, in vestibulum ante tincidunt vel.",
              align: TextAlign.center,
              color:
                  ThemeConfig.themeMode ? Colors.grey : Colors.grey.shade900),
        ),
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: double.infinity,
                width: getProportionateWidth(775),
                child: Center(
                  child: ClipRRect(
                    child: Image.asset(
                      'assets/images/android-studio-bumblebee.png',
                    ),
                    borderRadius:
                        BorderRadius.circular(getProportionateHeight(32)),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: -10,
                child: Image.asset(
                  'assets/images/android-studio.png',
                  height: getProportionateHeight(160),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: getProportionateHeight(8),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: getProportionateHeight(12),
              horizontal: getProportionateWidth(32)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                "Downloading Android Studio Chipmunk | 2021.2.1 for Mac",
                size: getProportionateHeight(18),
              ),
              TextWidget(
                "18%",
                size: getProportionateHeight(18),
                weight: FontWeight.bold,
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: getProportionateHeight(18),
          color: ThemeConfig.primary.withOpacity(0.2),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: Modifier.fillMaxWidth(1.0) * downloadPercentage,
                height: getProportionateHeight(32),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.horizontal(right: Radius.circular(28)),
                  color: ThemeConfig.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
