import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:masjid_noor_customer/mgr/models/jamah_md.dart';
import 'package:masjid_noor_customer/mgr/services/api_service.dart';

import '../../../mgr/models/bank_md.dart';
import 'package:app_settings/app_settings.dart';

class PrayerTime {
  final String name;
  final String time;

  PrayerTime({required this.name, required this.time});
}

class PrayerTimesController extends GetxController {
  static PrayerTimesController get to => Get.find();

  RxList<PrayerTime> prayerTimes = <PrayerTime>[].obs;
  RxBool isLoading = false.obs;
  RxString error = ''.obs;
  RxList<JamahMd> jamahs = <JamahMd>[].obs;
  Rx<Position?> currentPosition = Rx<Position?>(null);
  Rx<BankMd?> bankDetails = Rx<BankMd?>(null);

  Future<bool> getCurrentLocation(BuildContext context) async {
    isLoading.value = true;
    debugPrint("getCurrentLocation: Loading started");

    final hasPermission = await handleLocationPermission(context);
    if (!hasPermission) {
      debugPrint("getCurrentLocation: Permission denied");
      isLoading.value = false;
      return false;
    }

    try {
      debugPrint("getCurrentLocation: Fetching position");
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      debugPrint("getCurrentLocation: Position fetched: $position");

      currentPosition.value = position;

      debugPrint("getCurrentLocation: Fetching prayer times");
      await fetchPrayerTimes(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      debugPrint("getCurrentLocation: Prayer times fetched");

      return true;
    } catch (e) {
      debugPrint("getCurrentLocation: Error - ${e.toString()}");
      return false;
    } finally {
      isLoading.value = false;
      debugPrint("getCurrentLocation: Loading ended");
    }
  }

  Future<void> openAppSettings() async {
    await AppSettings.openAppSettings(type: AppSettingsType.location);
  }

  Future<void> fetchPrayerTimes(
      {required double latitude, required double longitude}) async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await http.get(Uri.parse(
          'http://api.aladhan.com/v1/timings/${DateTime.now().millisecondsSinceEpoch ~/ 1000}?latitude=$latitude&longitude=$longitude&method=2'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'];

        prayerTimes.value = [
          PrayerTime(name: 'Fajr', time: timings['Fajr']),
          PrayerTime(name: 'Dhuhr', time: timings['Dhuhr']),
          PrayerTime(name: 'Asr', time: timings['Asr']),
          PrayerTime(name: 'Maghrib', time: timings['Maghrib']),
          PrayerTime(name: 'Isha', time: timings['Isha']),
        ];
        await getJamah();
      } else {
        error.value = 'Failed to load prayer times';
      }
    } catch (e) {
      error.value = 'An error occurred: $e';
    }

    isLoading.value = false;
  }

  Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(milliseconds: 500),
          content: Text(
              'Location permissions are permanently denied. Please enable the permissions from the settings',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  height: 1.5))));
      return false;
    }
    return true;
  }

  Future getJamah() async {
    JamahMd masjidNoor = await ApiService().getJamahTime(1);
    JamahMd sejongDorm = await ApiService().getJamahTime(2);
    jamahs.value = [masjidNoor, sejongDorm];
  }

  Future getBankDetails() async {
    bankDetails.value = await ApiService().getBank(7);
  }
}
