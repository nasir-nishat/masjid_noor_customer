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
}
