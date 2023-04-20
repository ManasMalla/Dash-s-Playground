import 'dart:io';

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
  var isStatusReady = false;

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
      isStatusReady = true;
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
          Text(
            "Flutter SDK Location",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            flutterVersion,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Row(
            children: [
              updateFlutterSDKButtonState
                  ? Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2),
                          ),
                        ),
                        controller: flutterSdkUrlController,
                      ),
                    )
                  : Text(
                      flutterSdkUrl,
                    ),
              updateFlutterSDKButtonState
                  ? const SizedBox(
                      width: 42,
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
                child: Text(
                  updateFlutterSDKButtonState ? "Update" : "Change",
                ),
              ),
              const SizedBox(
                width: 42,
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "Android SDK Location",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              updateSDKButtonState
                  ? Expanded(
                      child: TextField(
                        cursorColor: Theme.of(context).colorScheme.primary,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2),
                          ),
                        ),
                        controller: sdkUrlController,
                      ),
                    )
                  : Text(
                      sdkUrl,
                    ),
              updateSDKButtonState
                  ? const SizedBox(
                      width: 42,
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
                child: Text(
                  updateSDKButtonState ? "Update" : "Change",
                ),
              ),
              const SizedBox(
                width: 42,
              )
            ],
          ),
          const Spacer(),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: !isStatusReady
                ? Center(child: CircularProgressIndicator())
                : isFlutterSDKUpToDate
                    ? SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/verified.png",
                              height: 100,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Text(
                              "You're all up-to-date!",
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                              style: Theme.of(context).textTheme.titleLarge,
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
                              height: 100,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Text(
                              "Update Available",
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
