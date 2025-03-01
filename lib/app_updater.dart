// 1. In your main.dart file, add code to check for updates on startup

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AppUpdater {
  // URL to your update manifest JSON file (hosted on GitHub or your server)
  final String updateManifestUrl;

  AppUpdater({required this.updateManifestUrl});

  Future<void> checkForUpdates(BuildContext context) async {
    try {
      // Get current app version
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      // Fetch update manifest
      final response = await http.get(Uri.parse(updateManifestUrl));
      if (response.statusCode != 200) {
        print('Failed to check for updates: ${response.statusCode}');
        return;
      }

      final updateInfo = json.decode(response.body);
      final latestVersion = updateInfo['version'];
      final apkUrl = updateInfo['url'];

      // Compare versions (this is a simple comparison, you might want a more sophisticated version comparison)
      if (_shouldUpdate(currentVersion, latestVersion)) {
        // Download and install the update
        await _downloadAndInstallUpdate(apkUrl);
      }
    } catch (e) {
      print('Error checking for updates: $e');
    }
  }

  bool _shouldUpdate(String currentVersion, String latestVersion) {
    // Simple version comparison (you might want to use a package for semantic versioning)
    List<int> current = currentVersion.split('.').map(int.parse).toList();
    List<int> latest = latestVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < current.length && i < latest.length; i++) {
      if (latest[i] > current[i]) return true;
      if (latest[i] < current[i]) return false;
    }

    return latest.length > current.length;
  }

  Future<void> _downloadAndInstallUpdate(String apkUrl) async {
    try {
      // Request installation permissions
      if (!await _requestInstallPermissions()) {
        print('Installation permissions not granted');
        return;
      }

      // Create a temporary directory to store the downloaded APK
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = '${tempDir.path}/app_update.apk';

      // Download the APK
      final response = await http.get(Uri.parse(apkUrl));
      if (response.statusCode != 200) {
        print('Failed to download update: ${response.statusCode}');
        return;
      }

      // Save the APK to the temporary directory
      final File file = File(tempPath);
      await file.writeAsBytes(response.bodyBytes);

      // Install the APK
      await _installApk(tempPath);
    } catch (e) {
      print('Error during update: $e');
    }
  }

  Future<bool> _requestInstallPermissions() async {
    if (Platform.isAndroid) {
      // Request INSTALL_PACKAGES permission through the DeviceAdminReceiver
      // This requires the device to be in device owner mode
      return true;  // Assuming device owner mode is already set up
    }
    return false;
  }

  Future<void> _installApk(String filePath) async {
    try {
      if (Platform.isAndroid) {
        // Use a method channel to communicate with native code for installation
        const platform = MethodChannel('com.mehenot.noormart/app_updater');
        await platform.invokeMethod('installApk', {'filePath': filePath});
      }
    } catch (e) {
      print('Error installing APK: $e');
    }
  }
}

// In your main.dart's initState or similar startup function:
void checkForAppUpdates(BuildContext context) {
  final updater = AppUpdater(
      updateManifestUrl: 'https://raw.githubusercontent.com/yourusername/yourrepo/main/update_manifest.json'
  );
  updater.checkForUpdates(context);
}