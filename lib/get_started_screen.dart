import 'dart:io';

import 'package:dash_playground/providers/installation_provider.dart';
import 'package:dash_playground/utils/platform_extension.dart';
import 'package:dash_playground/utils/size_config.dart';
import 'package:dash_playground/utils/switch.dart' as m3;
import 'package:dash_playground/utils/text_widget.dart';
import 'package:dash_playground/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FlutterChannel { stable, beta, dev, master }

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeConfig().init(context);
    return platformCategory() == PlatformCategory.desktop
        ? Consumer<InstallationProvider>(builder: (context, provider, _) {
            return ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
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
                      TextWidget(
                        "Choose Flutter Channel",
                        size: getProportionateHeight(24),
                        weight: FontWeight.w500,
                      ),
                      SizedBox(
                        height: getProportionateHeight(8),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: ThemeConfig.primary,
                        ),
                        child: Row(
                          children: [
                            FlutterChannel.stable,
                            FlutterChannel.beta,
                            FlutterChannel.dev,
                            FlutterChannel.master
                          ]
                              .map((e) => Expanded(
                                    child: Row(
                                      children: [
                                        Radio<FlutterChannel>(
                                            activeColor: ThemeConfig.primary,
                                            value: e,
                                            groupValue: provider.flutterChannel,
                                            onChanged: (_) {
                                              provider
                                                  .setFlutterChannel(_ ?? e);
                                            }),
                                        TextWidget(e.name.capitalize()),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      SizedBox(
                        height: getProportionateHeight(20),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  "Create Android Emulator",
                                  size: getProportionateHeight(24),
                                  weight: FontWeight.w500,
                                ),
                                TextWidget(
                                  "The Emulator is an emulation of a physical Android device to allow you to test your appications without an actual one",
                                  size: getProportionateHeight(16),
                                  color: (ThemeConfig.themeMode
                                          ? Colors.white
                                          : Colors.black)
                                      .withOpacity(0.3),
                                ),
                              ],
                            ),
                          ),
                          m3.Switch(
                              isEnabled: provider.deployEmulator,
                              onValueChange: () {
                                provider.setShouldDeployEmulator();
                              }),
                        ],
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: provider.deployEmulator
                            ? Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: ThemeConfig.primary,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: getProportionateHeight(20),
                                    ),
                                    TextWidget(
                                      "Choose Android Emulator Version",
                                      size: getProportionateHeight(24),
                                      weight: FontWeight.w500,
                                    ),
                                    SizedBox(
                                      height: getProportionateHeight(8),
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: {
                                              "Android 13 Preview": 33,
                                              "Android 12L": 32,
                                              "Android 12": 31,
                                            }
                                                .entries
                                                .map((e) => GridTile(
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Radio<int>(
                                                            activeColor:
                                                                ThemeConfig
                                                                    .primary,
                                                            value: e.value,
                                                            groupValue: provider
                                                                .emulatorAPI,
                                                            onChanged: (_) {
                                                              provider
                                                                  .setEmulatorDeploymentAPI(
                                                                      _ ??
                                                                          e.value);
                                                            },
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              TextWidget(
                                                                e.key,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              TextWidget(
                                                                e.value != 0
                                                                    ? " (SDK ${e.value})"
                                                                    : "",
                                                                weight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: {
                                              "Android 11": 30,
                                              "Android 10": 29,
                                              "Android 9": 28,
                                            }
                                                .entries
                                                .map((e) => GridTile(
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Radio<int>(
                                                            activeColor:
                                                                ThemeConfig
                                                                    .primary,
                                                            value: e.value,
                                                            groupValue: provider
                                                                .emulatorAPI,
                                                            onChanged: (_) {
                                                              provider
                                                                  .setEmulatorDeploymentAPI(
                                                                      _ ??
                                                                          e.value);
                                                            },
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              TextWidget(
                                                                e.key,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              TextWidget(
                                                                e.value != 0
                                                                    ? " (SDK ${e.value})"
                                                                    : "",
                                                                weight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: {
                                              "Android 8 and below": 0,
                                            }
                                                .entries
                                                .map((e) => GridTile(
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Radio<int>(
                                                            activeColor:
                                                                ThemeConfig
                                                                    .primary,
                                                            value: e.value,
                                                            groupValue: provider
                                                                .emulatorAPI,
                                                            onChanged: (_) {
                                                              provider
                                                                  .setEmulatorDeploymentAPI(
                                                                      _ ??
                                                                          e.value);
                                                            },
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              TextWidget(
                                                                e.key,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              TextWidget(
                                                                e.value != 0
                                                                    ? " (SDK ${e.value})"
                                                                    : "",
                                                                weight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ))
                                                .toList(),
                                          )
                                        ])
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ),
                      SizedBox(
                        height: getProportionateHeight(20),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  "Develop for Desktop",
                                  size: getProportionateHeight(24),
                                  weight: FontWeight.w500,
                                ),
                                TextWidget(
                                  "Installs ${Platform.isMacOS ? "Xcode" : Platform.isWindows ? "Visual Studio" : "3rd party dependencies like Clang, CMake, etc."}",
                                  size: getProportionateHeight(20),
                                  color: (ThemeConfig.themeMode
                                          ? Colors.white
                                          : Colors.black)
                                      .withOpacity(0.5),
                                ),
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
                          ),
                          m3.Switch(
                              isEnabled: provider.supportDesktop,
                              onValueChange: () {
                                provider.setDesktopSupport();
                              }),
                        ],
                      ),
                      SizedBox(
                        height: getProportionateHeight(20),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
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
                          ),
                          m3.Switch(
                              isEnabled: provider.useVisualStudioCodeAsIDE,
                              onValueChange: () {
                                provider.setVisualStudioCodeAsIDE();
                              }),
                        ],
                      ),
                      SizedBox(
                        height: getProportionateHeight(80),
                      )
                    ],
                  ),
                ),
              ),
            );
          })
        : const Center(child: Text("Mobile/Web"));
  }
}
