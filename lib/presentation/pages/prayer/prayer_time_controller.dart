import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrayerTime {
  final String name;
  final String time;
  final String? jamahTime;

  PrayerTime({required this.name, required this.time, this.jamahTime});
}

class PrayerTimesController extends GetxController {
  RxList<PrayerTime> prayerTimes = <PrayerTime>[].obs;
  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  RxString currentAddress = ''.obs;
  Rx<Position?> currentPosition = Rx<Position?>(null);

  Future<void> getCurrentPosition(BuildContext context) async {
    final hasPermission = await handleLocationPermission(context);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      currentPosition.value = position;
      fetchPrayerTimes(
          latitude: position.latitude, longitude: position.longitude);
    }).catchError((e) {
      debugPrint(e);
    });
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
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
}
