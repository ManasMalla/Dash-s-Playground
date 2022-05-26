import 'dart:io';

import 'package:flutter/foundation.dart';

PlatformCategory platformCategory() {
  return Platform.isMacOS || Platform.isLinux || Platform.isWindows
      ? PlatformCategory.desktop
      : kIsWeb
          ? PlatformCategory.web
          : PlatformCategory.mobile;
}

enum PlatformCategory { desktop, mobile, web }

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
