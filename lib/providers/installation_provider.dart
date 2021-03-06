import 'dart:io';

import 'package:dash_playground/get_started_screen.dart';
import 'package:flutter/material.dart';

class InstallationProvider extends ChangeNotifier {
  Map<String, String> urls = {};
  Map<String, int> sizes = {};

  FlutterChannel flutterChannel = FlutterChannel.stable;
  bool deployEmulator = false;
  int emulatorAPI = 33;
  bool useVisualStudioCodeAsIDE = false;
  bool supportDesktop = true;
  String androidStudioCodename = "";

  String currentlyDownloading = "";
  int downloadProgress = 0;
  var isExtracting = false;
  var isInstalling = false;
  var isCurrentlyDownloading = false;

  List<File> downloadedFiles = [];

  String accountPassword = "";

  addDownloadedFile(_) {
    downloadedFiles.add(_);
    notifyListeners();
  }

  setStatusAsDownloading() {
    isCurrentlyDownloading = true;
    notifyListeners();
  }

  setStatusDownloadComplete() {
    isCurrentlyDownloading = false;
    notifyListeners();
  }

  setStatusAsExtracting() {
    isExtracting = true;
    notifyListeners();
  }

  setStatusExtractionComplete() {
    isExtracting = false;
    notifyListeners();
  }

  setCurrentlyDownloading(_) {
    currentlyDownloading = _;
    notifyListeners();
  }

  setDownloadProgress(int _) {
    downloadProgress = _;
    notifyListeners();
  }

  setAndroidStudioCodename(_) {
    androidStudioCodename = _;
    notifyListeners();
  }

  setFlutterChannel(FlutterChannel _) {
    flutterChannel = _;
    notifyListeners();
  }

  setShouldDeployEmulator() {
    deployEmulator = !deployEmulator;
    notifyListeners();
  }

  setEmulatorDeploymentAPI(_) {
    emulatorAPI = _;
    notifyListeners();
  }

  setDesktopSupport() {
    supportDesktop = !supportDesktop;
    notifyListeners();
  }

  setVisualStudioCodeAsIDE() {
    useVisualStudioCodeAsIDE = !useVisualStudioCodeAsIDE;
    notifyListeners();
  }

  setAccountPassword(_) {
    accountPassword = _;
    notifyListeners();
  }

  void setIsInstalling(bool _) {
    isInstalling = _;
    notifyListeners();
  }
}
