import 'dart:io';

import 'package:dash_playground/presentation/platform/macos/app.dart';
import 'package:dash_playground/presentation/platform/mobile/app.dart';
import 'package:dash_playground/presentation/platform/windows/app.dart';
import 'package:dash_playground/providers/installation_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';

/**
 * MacOS based utility function to configure the window to match latest modern UI feels
 */
Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig(
    toolbarStyle: NSWindowToolbarStyle.unified,
  );
  await config.apply();
}

Future<void> main() async {
  if (kIsWeb) {
    // Run the web-specific code
  } else if (Platform.isWindows) {
    // Run the Windows-specific code
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider<InstallationProvider>(
        create: (_) => InstallationProvider(),
      ),
    ], child: const DashsPlaygroundWindowsApp()));
  } else if (Platform.isLinux) {
    // Run the Linux-specific code
  } else if (Platform.isMacOS) {
    // Run the macOS-specific code
    WidgetsFlutterBinding.ensureInitialized();
    await _configureMacosWindowUtils();
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider<InstallationProvider>(
        create: (_) => InstallationProvider(),
      ),
    ], child: const DashsPlaygroundMacOSApp()));
  } else {
    // Run the mobile-specific code
    runApp(const DashsPlaygroundApp());
  }
}
