import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dash_playground/get_started_screen.dart';
import 'package:dash_playground/providers/installation_provider.dart';
import 'package:dash_playground/providers/theme_provider.dart';
import 'package:dash_playground/utils/modifiers.dart';
import 'package:dash_playground/utils/size_config.dart';
import 'package:dash_playground/utils/text_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/shell.dart';
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
  String title = "";
  Dio dio = Dio();
  late Directory temporaryDirectory;
  var downloadIndex = 0;
  var urls = {};
  var numberOfZipDownloads = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    provider = Provider.of<InstallationProvider>(context, listen: false);

    if (!provider.isCurrentlyDownloading) {
      getTemporaryDirectory().then((_) async {
        temporaryDirectory = _;
        //get url
        var forPlatform =
            'for ${Platform.isMacOS ? "Mac" : Platform.isWindows ? "Windows" : "Linux"}';
        var flutterSDKVersionText = provider.flutterChannel ==
                FlutterChannel.master
            ? ""
            : provider.urls['Flutter SDK (${provider.flutterChannel.name})']
                ?.split(
                    "flutter_${Platform.isMacOS ? "macos" : Platform.isWindows ? "windows" : "linux"}_")
                .last
                .split("-")
                .first;
        urls = {
          'Android Studio ${provider.androidStudioCodename} | ${provider.urls['Android Studio']?.split("android-studio-").last.split("-").first.split(".").take(3).join(".")} $forPlatform':
              provider.urls['Android Studio'],
          'Command Line Tools $forPlatform':
              provider.urls['Command Line Tools'],
          'OpenJDK ${provider.urls['OpenJDK']?.split("openjdk-").last.split("_").first.split(".").take(3).join(".")} $forPlatform':
              provider.urls['OpenJDK'],
          'Flutter SDK $flutterSDKVersionText (${provider.flutterChannel.name}) $forPlatform':
              provider.urls['Flutter SDK (${provider.flutterChannel.name})'],
        };

        //Terminal/CMD/Shell - Android SDK Components, Android Emulator, Desktop Tools
        if (provider.useVisualStudioCodeAsIDE) {
          urls['Visual Studio Code $forPlatform'] =
              (provider.urls['Visual Studio Code']);
          numberOfZipDownloads++;
        }
        //download the files
        downloadAndInstallFile(urls.entries.toList()[downloadIndex]);
      });
    }
  }

  downloadAndInstallFile(entry) {
    provider.setStatusAsDownloading();
    var url = entry.value;
    provider.setCurrentlyDownloading(entry.key);
    var fileName = entry.key.contains("Visual Studio Code")
        ? Platform.isMacOS
            ? "VSCode-darwin.zip"
            : Platform.isLinux
                ? "/Visual Studio Code/code-stable-x64.tar.gz"
                : "/Visual Studio Code/VSCode-win32-x64.zip"
        : provider.flutterChannel == FlutterChannel.master
            ? "flutter-master.zip"
            : url?.split("/").last;
    var fileURL = "${temporaryDirectory.path}/Dash's Playground/$fileName";
    if (url != null) {
      dio.download(
        url,
        fileURL,
        onReceiveProgress: (count, total) {
          var percentage = count * 100 / total;
          provider.setDownloadProgress(percentage.round());
        },
      ).then((value) {
        File downloadedFile = File(fileURL);
        provider.addDownloadedFile(downloadedFile);
        provider.setStatusAsExtracting();
        unarchiveAndSave(
          downloadedFile,
          "${temporaryDirectory.path}/Dash's Playground${entry.key.contains("Visual Studio Code") && Platform.isWindows ? "/Visual Studio Code" : ""}",
        );
      });
    }
  }

  unarchiveAndSave(File zippedFile, _dir) async {
    var bytes = zippedFile.readAsBytesSync();
    if (zippedFile.path.endsWith(".zip")) {
      var archive = ZipDecoder().decodeBytes(bytes);
      for (var file in archive) {
        var fileName = '$_dir/${file.name}';
        if (file.isFile) {
          var outFile = File(fileName);
          provider.setDownloadProgress(
              (archive.files.indexOf(file) * 100 / archive.length).round());
          outFile = await outFile.create(recursive: true);
          outFile.writeAsBytes(file.content);
        }
      }
      if (downloadIndex < numberOfZipDownloads) {
        provider.setStatusExtractionComplete();
        downloadIndex++;
        downloadAndInstallFile(urls.entries.toList()[downloadIndex]);
      } else {
        provider.setStatusDownloadComplete();
        runCHMOD();
      }
    } else {
      var tarArchive = GZipDecoder().decodeBytes(bytes);
      var archive = TarDecoder().decodeBytes(tarArchive);
      for (var file in archive) {
        var fileName = '$_dir/${file.name}';
        if (file.isFile) {
          var outFile = File(fileName);
          provider.setDownloadProgress(
              (archive.files.indexOf(file) * 100 / archive.length).round());
          outFile = await outFile.create(recursive: true);
          outFile.writeAsBytes(file.content);
        }
      }
      if (downloadIndex < numberOfZipDownloads) {
        provider.setStatusExtractionComplete();
        downloadIndex++;
        downloadAndInstallFile(urls.entries.toList()[downloadIndex]);
      } else {
        provider.setStatusDownloadComplete();
        runCHMOD();
      }
    }
  }

  runCHMOD() {
    if (!Platform.isWindows) {
      Shell shell = Shell();
      shell.run('chmod -R +x "${temporaryDirectory.path}/Dash\'s Playground"');
      deleteZips();
    } else {
      deleteZips();
    }
  }

  deleteZips() {
    var zipsToBeDeleted = provider.downloadedFiles;
    for (var file in zipsToBeDeleted) {
      file.delete(recursive: true);
    }

    if (Platform.isMacOS) {
      getLibraryDirectory().then((value) {
        value.exists().then((exits) {
          Shell shell1 = Shell(
              workingDirectory: "${Platform.environment['LocalAppData']}");
          shell1.run("mkdir Android").then((_) {
            moveFiles(exits ? value.path : "");
          });
        });
      });
    } else {
      Shell shell1 =
          Shell(workingDirectory: "${Platform.environment['LocalAppData']}");
      shell1.run("mkdir Android").then((_) {
        moveFiles("");
      });
    }
  }

  moveFiles(lib) {
    var windowsHome = "${temporaryDirectory.path.split("AppData").first}";
    var directory = Directory("${temporaryDirectory.path}/Dash's Playground/");
    var files = directory.listSync(recursive: false);
    var paths = {};
    for (var element in files) {
      print(element.path);
      if (element.path.contains("Android") ||
          element.path.contains("android")) {
        paths["Android Studio"] = [
          element.path,
          Platform.isMacOS
              ? "/Applications"
              : Platform.isWindows
                  ? "${windowsHome}Android"
                  : "/usr/local/android-studio"
        ];
      } else if (element.path.contains("jdk")) {
        paths["OpenJDK"] = [
          element.path,
          Platform.isMacOS
              ? '$lib/Java/JavaVirtualMachines'
              : Platform.isWindows
                  ? '${windowsHome}Java'
                  : '/usr/lib/jvm'
        ];
      } else if (element.path.contains("cmdline")) {
        paths["Command Line Tools"] = [
          element.path,
          Platform.isMacOS
              ? '$lib/Android/sdk'
              : Platform.isWindows
                  ? '${Platform.environment['LocalAppData']}/Android/sdk'
                  : '/usr/lib/android-sdk'
        ];
      } else if (element.path.contains("Visual Studio Code") ||
          element.path.contains("VisualStudioCode")) {
        paths["Visual Studio Code"] = [
          element.path,
          Platform.isMacOS
              ? "/Applications"
              : Platform.isWindows
                  ? "${windowsHome}"
                  : "/usr/local/visual-studio-code"
        ];
      } else if (element.path.contains("flutter")) {
        paths["Flutter SDK"] = [
          element.path,
          Platform.isMacOS
              ? "$lib/Flutter-SDK/"
              : Platform.isWindows
                  ? "${windowsHome}Flutter-SDK"
                  : "/usr/local/flutter-sdk"
        ];
      }
    }
    paths.forEach((key, value) async {
      provider.setCurrentlyDownloading(key);
      provider.setDownloadProgress(0);
      provider.setIsInstalling(true);
      print("$key $value");
      var shell = Shell();

      shell
          .run(
              '${Platform.isWindows ? 'move' : 'mv'} "${value[0]}" "${value[1]}"')
          .then((value) async {
        for (var element in value) {
          provider.setDownloadProgress(100);
          provider.setIsInstalling(false);
          if (Platform.isWindows) {
            if (key.toString().contains("Android")) {
              await createShortcuts(
                  "${windowsHome}Android/bin/studio64.exe", windowsHome, key);
            } else {
              if (key.toString().contains("Visual")) {
                await createShortcuts(
                    "${windowsHome}Visual Studio Code/Code.exe",
                    windowsHome,
                    key);
              }
            }
          }
        }
      });
    });
  }

  createShortcuts(target, windowsHome, key) async {
    Shell shell = Shell();
    await shell.run('''   
    \$strTargetPath = "$target"
   \$strLinkFile = "${windowsHome}Desktop/${key == "AS" ? "Android Studio" : "Visual Studio Code"}.lnk"
   \$WScriptShell = New-Object -ComObject WScript.Shell
   \$Shortcut = \$WScriptShell.CreateShortcut(\$strLinkFile)
   \$Shortcut.TargetPath = \$strTargetPath
   \$Shortcut.Save()
   ''');
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
          child: Consumer<InstallationProvider>(
              builder: (context, progressProvider, __) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  "${provider.isExtracting ? "Extracting" : provider.isInstalling ? "Installing" : "Downloading"} ${progressProvider.currentlyDownloading}",
                  size: getProportionateHeight(18),
                ),
                provider.isInstalling
                    ? SizedBox()
                    : TextWidget(
                        "${progressProvider.downloadProgress}%",
                        size: getProportionateHeight(18),
                        weight: FontWeight.bold,
                      ),
              ],
            );
          }),
        ),
        Container(
          width: double.infinity,
          height: getProportionateHeight(18),
          color: ThemeConfig.primary.withOpacity(0.2),
          child: Stack(
            children: [
              Consumer<InstallationProvider>(
                  builder: (context, progressProvider, _) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: ((Modifier.fillMaxWidth(1.0) -
                              getProportionateWidth(360)) *
                          progressProvider.downloadProgress) /
                      100,
                  height: getProportionateHeight(32),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(28)),
                    color: ThemeConfig.primary,
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
