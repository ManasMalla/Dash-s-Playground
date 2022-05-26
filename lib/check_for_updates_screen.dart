import 'dart:io';

import 'package:dash_playground/utils/size_config.dart';
import 'package:dash_playground/utils/text_widget.dart';
import 'package:dash_playground/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';

class CheckForUpdatesScreen extends StatefulWidget {
  const CheckForUpdatesScreen({Key? key}) : super(key: key);

  @override
  State<CheckForUpdatesScreen> createState() => _CheckForUpdatesScreenState();
}

class _CheckForUpdatesScreenState extends State<CheckForUpdatesScreen> {
  var username = "USER%NAME";

  var sdkUrl = "";
  var flutterSdkUrl = "";
  var flutterVersion = "";

  var updateSDKButtonState = false;
  var updateFlutterSDKButtonState = false;

  var sdkUrlController = TextEditingController(text: "");
  var flutterSdkUrlController = TextEditingController(text: "");

  var isFlutterSDKUpToDate = true;

  checkIfSDKExists(directory, sdk) {
    Process.run("cd", [directory]).then((result) {
      if (result.stderr.toString().contains("No such file or directory") ||
          result.stderr.toString().contains("no")) {
        //No SDK found
        sdk == "android"
            ? sdkUrl = "No SDK Found!"
            : flutterSdkUrl = "No SDK Found!";

        setState(() {});
      } else {
        if (sdk == "flutter") {
          //SDK exists
          var shell = Shell();

          shell.run('flutter --version').then((value) {
            flutterVersion = value.outText.split("•")[0];
            setState(() {});
          });
        }
      }
    });
  }

  getSdkLocation() {
    if (Platform.isMacOS) {
      Process.run("id", ["-un"]).then((result) {
        username = result.stdout.replaceAll("\n", "");
        sdkUrl = "/Users/$username/Library/Android/sdk";
        sdkUrlController.text = sdkUrl;

        checkIfSDKExists(sdkUrl, "android");

        setState(() {});
      });
    } else if (Platform.isWindows) {
      Process.run("%USERNAME%", []).then((result) {
        username = result.stdout.replaceAll("\n", "");
        sdkUrl = "C:\\Users\\$username\\AppData\\Local\\Android\\sdk";
        sdkUrlController.text = sdkUrl;

        checkIfSDKExists(sdkUrl, "android");
        setState(() {});
      });
    } else if (Platform.isLinux) {
      Process.run("echo \$USER", []).then((result) {
        username = result.stdout.replaceAll("\n", "");
        sdkUrl = "/home/$username/Android/Sdk";
        sdkUrlController.text = sdkUrl;

        checkIfSDKExists(sdkUrl, "android");
        setState(() {});
      });
    }
  }

  getFlutterSdkLocation() {
    flutterSdkUrl =
        (whichSync('flutter') ?? "").replaceFirst("/bin/flutter", "/bin");
    flutterSdkUrlController.text = flutterSdkUrl;
    checkIfSDKExists(flutterSdkUrl, "flutter");
    setState(() {});
  }

  checkForUpdates() {
    var shell = Shell();

    shell.run("flutter upgrade --verify-only").then((value) {
      isFlutterSDKUpToDate =
          value.outText.contains("Flutter is already up to date on channel");
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getSdkLocation();
    getFlutterSdkLocation();
    checkForUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            "Flutter SDK Location",
            color: ThemeConfig.primary,
            size: getProportionateHeight(24),
            weight: FontWeight.w500,
          ),
          SizedBox(
            height: getProportionateHeight(8),
          ),
          TextWidget(
            flutterVersion,
            color: ThemeConfig.primary.withOpacity(0.6),
            size: getProportionateHeight(20),
            weight: FontWeight.w500,
          ),
          Row(
            children: [
              updateFlutterSDKButtonState
                  ? Expanded(
                      child: TextField(
                        cursorColor: ThemeConfig.primary,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: ThemeConfig.primary, width: 2),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: ThemeConfig.primary, width: 2),
                          ),
                        ),
                        controller: flutterSdkUrlController,
                        style: TextStyle(
                            fontFamily: 'Product Sans',
                            fontSize: getProportionateHeight(18)),
                      ),
                    )
                  : TextWidget(
                      flutterSdkUrl,
                      size: getProportionateHeight(18),
                    ),
              updateFlutterSDKButtonState
                  ? SizedBox(
                      width: getProportionateWidth(42),
                    )
                  : const Spacer(),
              TextButton(
                onPressed: () {
                  if (updateFlutterSDKButtonState) {
                    flutterSdkUrl = flutterSdkUrlController.text;
                    checkIfSDKExists(flutterSdkUrl, "flutter");
                  }
                  updateFlutterSDKButtonState = !updateFlutterSDKButtonState;
                  setState(() {});
                },
                child: TextWidget(
                  updateFlutterSDKButtonState ? "Update" : "Change",
                  size: getProportionateHeight(18),
                  weight: FontWeight.w500,
                  color: ThemeConfig.themeMode
                      ? Colors.blue.shade400
                      : Colors.blue.shade700,
                ),
              ),
              SizedBox(
                width: getProportionateWidth(42),
              )
            ],
          ),
          SizedBox(
            height: getProportionateHeight(12),
          ),
          TextWidget(
            "Android SDK Location",
            color: ThemeConfig.primary,
            size: getProportionateHeight(24),
            weight: FontWeight.w500,
          ),
          SizedBox(
            height: getProportionateHeight(8),
          ),
          Row(
            children: [
              updateSDKButtonState
                  ? Expanded(
                      child: TextField(
                        cursorColor: ThemeConfig.primary,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: ThemeConfig.primary, width: 2),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: ThemeConfig.primary, width: 2),
                          ),
                        ),
                        controller: sdkUrlController,
                        style: TextStyle(
                            fontFamily: 'Product Sans',
                            fontSize: getProportionateHeight(18)),
                      ),
                    )
                  : TextWidget(
                      sdkUrl,
                      size: getProportionateHeight(18),
                    ),
              updateSDKButtonState
                  ? SizedBox(
                      width: getProportionateWidth(42),
                    )
                  : const Spacer(),
              TextButton(
                onPressed: () {
                  if (updateSDKButtonState) {
                    sdkUrl = sdkUrlController.text;
                    checkIfSDKExists(sdkUrl, "android");
                  }
                  updateSDKButtonState = !updateSDKButtonState;
                  setState(() {});
                },
                child: TextWidget(
                  updateSDKButtonState ? "Update" : "Change",
                  size: getProportionateHeight(18),
                  weight: FontWeight.w500,
                  color: ThemeConfig.themeMode
                      ? Colors.blue.shade400
                      : Colors.blue.shade700,
                ),
              ),
              SizedBox(
                width: getProportionateWidth(42),
              )
            ],
          ),
          const Spacer(),
          isFlutterSDKUpToDate
              ? SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/verified.png",
                        height: getProportionateHeight(100),
                      ),
                      SizedBox(
                        height: getProportionateHeight(24),
                      ),
                      TextWidget(
                        "You're all up-to-date!",
                        color: ThemeConfig.primary,
                        size: getProportionateHeight(36),
                        weight: FontWeight.w700,
                      ),
                      TextWidget(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                        color: ThemeConfig.primary.withOpacity(0.8),
                        size: getProportionateHeight(20),
                        weight: FontWeight.w500,
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/update_available.png",
                        height: getProportionateHeight(100),
                      ),
                      SizedBox(
                        height: getProportionateHeight(24),
                      ),
                      TextWidget(
                        "Update Available",
                        color: ThemeConfig.primary,
                        size: getProportionateHeight(36),
                        weight: FontWeight.w700,
                      ),
                      TextWidget(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                        color: ThemeConfig.primary.withOpacity(0.8),
                        size: getProportionateHeight(20),
                        weight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
          const Spacer(),
        ],
      ),
    );
  }
}
