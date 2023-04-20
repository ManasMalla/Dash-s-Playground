import 'dart:io';

import 'package:dash_playground/providers/installation_provider.dart';
import 'package:dash_playground/utils/flutter_channel_enum.dart';
import 'package:dash_playground/utils/platform_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return platformCategory() == PlatformCategory.desktop
        ? Consumer<InstallationProvider>(builder: (context, provider, _) {
            return ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Get Started",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: 600,
                        child: Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean placerat sapien at porttitor malesuada. Etiam accumsan imperdiet ante in iaculis. Proin metus tellus, sollicitudin sit amet aliquet vel, iaculis eu orci. Fusce vitae mi at lorem vehicula hendrerit. Donec eget purus sed dolor egestas placerat. Morbi sed semper ligula. Interdum et malesuada fames ac ante ipsum primis in faucibus."),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Components that will be installed:",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/android-studio.png',
                            height: 54,
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          const Text(
                            "android studio",
                          ),
                          const Spacer(),
                          Image.asset(
                            'assets/images/openJDK.png',
                            height: 54,
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          const Text(
                            "OpenJDK",
                          ),
                          const Spacer(),
                          Image.asset(
                            'assets/images/flutter-logo.png',
                            height: 54,
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          const Text(
                            "Flutter SDK",
                          ),
                          const SizedBox(
                            width: 48,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Choose Flutter Channel",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          FlutterChannel.stable,
                          FlutterChannel.beta,
                          FlutterChannel.master
                        ]
                            .map((e) => Expanded(
                                  child: Row(
                                    children: [
                                      Radio<FlutterChannel>(
                                          value: e,
                                          groupValue: provider.flutterChannel,
                                          onChanged: (_) {
                                            provider.setFlutterChannel(_ ?? e);
                                          }),
                                      Text(
                                        e.name.capitalize(),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Create Android Emulator",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  "The Emulator is an emulation of a physical Android device to allow you to test your appications without an actual one",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          Switch(
                              value: provider.deployEmulator,
                              onChanged: (_) {
                                provider.setShouldDeployEmulator();
                              }),
                        ],
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: provider.deployEmulator
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Choose Android Emulator Version",
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              e.key,
                                                            ),
                                                            Text(
                                                              e.value != 0
                                                                  ? " (SDK ${e.value})"
                                                                  : "",
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
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              e.key,
                                                            ),
                                                            Text(
                                                              e.value != 0
                                                                  ? " (SDK ${e.value})"
                                                                  : "",
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
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              e.key,
                                                            ),
                                                            Text(
                                                              e.value != 0
                                                                  ? " (SDK ${e.value})"
                                                                  : "",
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
                              )
                            : const SizedBox(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Develop for Desktop",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  "Installs ${Platform.isMacOS ? "Xcode" : Platform.isWindows ? "Visual Studio" : "3rd party dependencies like Clang, CMake, etc."}",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const Text(
                                  "Build high-quality desktop apps without compromising \ncompatibility or performance.",
                                ),
                              ],
                            ),
                          ),
                          Switch(
                              value: provider.supportDesktop,
                              onChanged: (_) {
                                provider.setDesktopSupport();
                              }),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Use Visual Studio Code as your IDE",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const Text(
                                  "Visual Studio Code is a 3rd party IDE developed by Microsoft",
                                ),
                              ],
                            ),
                          ),
                          Switch(
                              value: provider.useVisualStudioCodeAsIDE,
                              onChanged: (_) {
                                provider.setVisualStudioCodeAsIDE();
                              }),
                        ],
                      ),
                      const SizedBox(
                        height: 80,
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
