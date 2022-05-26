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
}
