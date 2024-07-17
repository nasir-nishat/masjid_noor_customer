import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:masjid_noor_customer/mgr/models/jamah_md.dart';
import 'package:masjid_noor_customer/mgr/services/api_service.dart';

import '../../../mgr/models/bank_md.dart';

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

  Future<void> getCurrentLocation(BuildContext context) async {
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
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
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
