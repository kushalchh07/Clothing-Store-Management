// platform_native.dart
import 'dart:io';

class PlatformHelper {
  static bool get isWindows => Platform.isWindows;
  static bool get isMacOS => Platform.isMacOS;
  static bool get isLinux => Platform.isLinux;
  static bool get isWeb => false;
}
