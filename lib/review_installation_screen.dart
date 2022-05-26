import 'dart:io';

import 'package:dash_playground/providers/installation_provider.dart';
import 'package:dash_playground/utils/platform_extension.dart';
import 'package:dash_playground/utils/size_config.dart';
import 'package:dash_playground/utils/text_widget.dart';
import 'package:dash_playground/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewInstallationScreen extends StatefulWidget {
  const ReviewInstallationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ReviewInstallationScreen> createState() =>
      _ReviewInstallationScreenState();
}

class _ReviewInstallationScreenState extends State<ReviewInstallationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late InstallationProvider provider;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    provider = Provider.of<InstallationProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  var targetAPIs = const {
    33: "Android 13 Preview",
    32: "Android 12L",
    31: "Android 12",
    30: "Android 11",
    29: "Android 10",
    28: "Android 9",
    0: "Android 8 and below",
  };
  var androidImages = const {
    33: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/22/Android_13_Developer_Preview_logo.svg/1200px-Android_13_Developer_Preview_logo.svg.png',
    32: 'https://www.howtogeek.com/wp-content/uploads/2021/11/Android-12L.png?width=1198&trim=1,1&bg-color=000&pad=1,1',
    31: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Android_12_Developer_Preview_logo.svg/1200px-Android_12_Developer_Preview_logo.svg.png',
    30: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Android_11_Developer_Preview_logo.svg/1200px-Android_11_Developer_Preview_logo.svg.png',
    29: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Android_Q_Logo.svg/1024px-Android_Q_Logo.svg.png',
    28: 'https://www.xda-developers.com/files/2018/08/Android-9-Pie-slice-featured-1900x700_c.png',
    0: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Android_Oreo_8.1_logo.svg/1200px-Android_Oreo_8.1_logo.svg.png',
  };

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: getProportionateHeight(24),
              ),
              TextWidget(
                "Components that will be installed:",
                size: getProportionateHeight(24),
                weight: FontWeight.w500,
              ),
              SizedBox(
                height: getProportionateHeight(8),
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/android-studio.png',
                    height: getProportionateHeight(54),
                  ),
                  SizedBox(
                    width: getProportionateWidth(24),
                  ),
                  TextWidget(
                    "android studio",
                    weight: FontWeight.w500,
                    size: getProportionateHeight(20),
                  ),
                  const Spacer(),
                  Image.asset(
                    'assets/images/openJDK.png',
                    height: getProportionateHeight(54),
                  ),
                  SizedBox(
                    width: getProportionateWidth(24),
                  ),
                  TextWidget(
                    "OpenJDK",
                    weight: FontWeight.w500,
                    size: getProportionateHeight(20),
                  ),
                  const Spacer(),
                  Image.asset(
                    'assets/images/flutter-logo.png',
                    height: getProportionateHeight(54),
                  ),
                  SizedBox(
                    width: getProportionateWidth(24),
                  ),
                  TextWidget(
                    "Flutter SDK",
                    weight: FontWeight.w500,
                    size: getProportionateHeight(20),
                  ),
                  SizedBox(
                    width: getProportionateWidth(48),
                  )
                ],
              ),
              SizedBox(
                height: getProportionateHeight(20),
              ),
              Row(
                children: [
                  TextWidget(
                    "Flutter Channel: ",
                    size: getProportionateHeight(24),
                    weight: FontWeight.w500,
                  ),
                  SizedBox(
                    height: getProportionateHeight(8),
                  ),
                  TextWidget(
                    provider.flutterChannel.name.capitalize(),
                    size: getProportionateHeight(24),
                    weight: FontWeight.w500,
                    color: ThemeConfig.primary,
                  ),
                ],
              ),
              SizedBox(
                height: getProportionateHeight(20),
              ),
              provider.deployEmulator
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          "Android Emulator",
                          size: getProportionateHeight(24),
                          weight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: getProportionateHeight(8),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            provider.emulatorAPI != 33
                                ? ClipOval(
                                    child: Image.network(
                                      androidImages[provider.emulatorAPI] ??
                                          "https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Android_Oreo_8.1_logo.svg/1200px-Android_Oreo_8.1_logo.svg.png",
                                      height: getProportionateHeight(40),
                                      width: getProportionateHeight(40),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.network(
                                    androidImages[provider.emulatorAPI] ??
                                        "https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Android_Oreo_8.1_logo.svg/1200px-Android_Oreo_8.1_logo.svg.png",
                                    height: getProportionateHeight(40),
                                  ),
                            SizedBox(
                              width: getProportionateWidth(24),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  targetAPIs[provider.emulatorAPI] ?? "",
                                  size: getProportionateHeight(24),
                                  weight: FontWeight.w500,
                                  color: (ThemeConfig.themeMode
                                          ? Colors.white
                                          : Colors.black)
                                      .withOpacity(0.7),
                                ),
                                TextWidget(
                                  provider.emulatorAPI != 0
                                      ? "SDK ${provider.emulatorAPI}"
                                      : "",
                                  size: getProportionateHeight(18),
                                  weight: FontWeight.w700,
                                  color: Colors.grey.shade600,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
              provider.deployEmulator
                  ? SizedBox(
                      height: getProportionateHeight(20),
                    )
                  : const SizedBox(),
              provider.supportDesktop
                  ? TextWidget(
                      "Develop for Desktop",
                      size: getProportionateHeight(24),
                      weight: FontWeight.w500,
                    )
                  : const SizedBox(),
              provider.supportDesktop
                  ? SizedBox(
                      height: getProportionateHeight(8),
                    )
                  : const SizedBox(),
              provider.supportDesktop
                  ? Row(
                      children: [
                        Image.network(
                          Platform.isMacOS
                              ? 'https://upload.wikimedia.org/wikipedia/en/0/0c/Xcode_icon.png'
                              : Platform.isWindows
                                  ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/Visual_Studio_Icon_2019.svg/1200px-Visual_Studio_Icon_2019.svg.png'
                                  : 'https://upload.wikimedia.org/wikipedia/commons/8/8a/Apt-get_logo.jpg',
                          height: getProportionateHeight(54),
                        ),
                        SizedBox(
                          width: getProportionateWidth(24),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                                "Installs ${Platform.isMacOS ? "Xcode" : Platform.isWindows ? "Visual Studio" : "3rd party dependencies like Clang, CMake, etc."}",
                                size: getProportionateHeight(20),
                                color: (ThemeConfig.themeMode
                                    ? Colors.white
                                    : Colors.black)),
                            TextWidget(
                              "Build high-quality desktop apps without compromising \ncompatibility or performance.",
                              size: getProportionateHeight(16),
                              color: (ThemeConfig.themeMode
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(0.3),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
              SizedBox(
                height:
                    getProportionateHeight(provider.supportDesktop ? 20 : 0),
              ),
              provider.useVisualStudioCodeAsIDE
                  ? TextWidget(
                      "Integrated Development Environment",
                      size: getProportionateHeight(24),
                      weight: FontWeight.bold,
                    )
                  : const SizedBox(),
              provider.useVisualStudioCodeAsIDE
                  ? SizedBox(
                      height: getProportionateHeight(8),
                    )
                  : const SizedBox(),
              provider.useVisualStudioCodeAsIDE
                  ? Row(
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Visual_Studio_Code_1.35_icon.svg/2048px-Visual_Studio_Code_1.35_icon.svg.png',
                          height: getProportionateHeight(36),
                        ),
                        SizedBox(
                          width: getProportionateWidth(24),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              "Use Visual Studio Code as your IDE",
                              size: getProportionateHeight(24),
                              weight: FontWeight.w500,
                            ),
                            TextWidget(
                              "Visual Studio Code is a 3rd party IDE developed by Microsoft",
                              size: getProportionateHeight(16),
                              color: (ThemeConfig.themeMode
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(0.3),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
              SizedBox(
                height: getProportionateHeight(20),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    "Note: ",
                    size: getProportionateHeight(16),
                    color: const Color(0xFF54c5f8),
                    weight: FontWeight.bold,
                  ),
                  SizedBox(
                    width: getProportionateWidth(8),
                  ),
                  Expanded(
                    child: TextWidget(
                        "Android Studio's bin folder and OpenJDK's bin will be added to the PATH variable in the System Environmental Variables",
                        size: getProportionateHeight(16),
                        weight: FontWeight.w500,
                        color: (ThemeConfig.themeMode
                            ? Colors.white
                            : Colors.black)),
                  ),
                ],
              ),
              SizedBox(
                height: getProportionateHeight(20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextWidget(
                    "Total Download Size: ",
                    color: const Color(0xFF54c5f8),
                    size: getProportionateHeight(20),
                  ),
                  TextWidget(
                    "${(provider.sizes['Flutter SDK'] ?? 0) + (provider.sizes['Command Line Tools'] ?? 0) + (provider.sizes['Android Studio'] ?? 0) + (provider.sizes['OpenJDK'] ?? 0) + (provider.useVisualStudioCodeAsIDE ? provider.sizes['Visual Studio Code'] ?? 0 : 0) + (provider.supportDesktop ? provider.sizes['desktop-tools'] ?? 0 : 0) + (provider.deployEmulator ? provider.sizes['systemImageSDK${provider.emulatorAPI}'] ?? 0 : 0)} MiB",
                    size: getProportionateHeight(32),
                    weight: FontWeight.bold,
                    color: ThemeConfig.onBackground,
                  ),
                ],
              ),
              SizedBox(
                height: getProportionateHeight(80),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
