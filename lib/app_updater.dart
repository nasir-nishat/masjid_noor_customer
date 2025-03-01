import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AppUpdater {
  // URL to your update manifest JSON file (adjust if using Supabase or other host)
  final String updateManifestUrl;

  AppUpdater({required this.updateManifestUrl});

  Future<void> checkForUpdates(BuildContext context) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      final response = await http.get(Uri.parse(updateManifestUrl));
      if (response.statusCode != 200) {
        print('Failed to check for updates: ${response.statusCode}');
        return;
      }

      final updateInfo = json.decode(response.body);
      final latestVersion = updateInfo['version'];
      final apkUrl = updateInfo['url'];

      if (_shouldUpdate(currentVersion, latestVersion)) {
        await _downloadAndInstallUpdate(apkUrl);
      }
    } catch (e) {
      print('Error checking for updates: $e');
    }
  }

  bool _shouldUpdate(String currentVersion, String latestVersion) {
    List<int> current = currentVersion.split('.').map(int.parse).toList();
    List<int> latest = latestVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < current.length && i < latest.length; i++) {
      if (latest[i] > current[i]) return true;
      if (latest[i] < current[i]) return false;
    }
    return latest.length > current.length;
  }

  Future<void> _downloadAndInstallUpdate(String apkUrl) async {
    if (!await _requestInstallPermissions()) {
      print('Installation permissions not granted');
      return;
    }

    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = '${tempDir.path}/app_update.apk';

    final response = await http.get(Uri.parse(apkUrl));
    if (response.statusCode != 200) {
      print('Failed to download update: ${response.statusCode}');
      return;
    }

    final File file = File(tempPath);
    await file.writeAsBytes(response.bodyBytes);

    await _installApk(tempPath);
  }

  Future<bool> _requestInstallPermissions() async {
    if (Platform.isAndroid) {
      // Assuming device owner mode is already set up.
      return true;
    }
    return false;
  }

  Future<void> _installApk(String filePath) async {
    try {
      if (Platform.isAndroid) {
        const platform = MethodChannel('com.mehenot.noormart/app_updater');
        await platform.invokeMethod('installApk', {'filePath': filePath});
      }
    } catch (e) {
      print('Error installing APK: $e');
    }
  }
}

void checkForAppUpdates(BuildContext context) {
  final updater = AppUpdater(
      updateManifestUrl: 'https://nsyflgowjqaunfbechqh.supabase.co/storage/v1/object/public/updates/update_manifest.json'
  );
  updater.checkForUpdates(context);
}
