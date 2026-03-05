import 'package:flutter/foundation.dart';

class AppLogger {
  const AppLogger._();

  static void warn(String message) {
    debugPrint('[WARN] $message');
  }

  static void error(String message) {
    debugPrint('[ERROR] $message');
  }
}
