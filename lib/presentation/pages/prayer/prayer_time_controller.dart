import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrayerTimesController extends GetxController {
  var fajr = TimeOfDay(hour: 5, minute: 0).obs;
  var dhuhr = TimeOfDay(hour: 12, minute: 0).obs;
  var asr = TimeOfDay(hour: 15, minute: 0).obs;
  var maghrib = TimeOfDay(hour: 18, minute: 0).obs;
  var isha = TimeOfDay(hour: 20, minute: 0).obs;

  void setTime(String prayer, TimeOfDay time) {
    switch (prayer) {
      case 'Fajr':
        fajr.value = time;
        break;
      case 'Dhuhr':
        dhuhr.value = time;
        break;
      case 'Asr':
        asr.value = time;
        break;
      case 'Maghrib':
        maghrib.value = time;
        break;
      case 'Isha':
        isha.value = time;
        break;
      default:
        break;
    }
  }

  void savePrayerTimes() {
    print('Fajr: ${fajr.value.format(Get.context!)}');
    print('Dhuhr: ${dhuhr.value.format(Get.context!)}');
    print('Asr: ${asr.value.format(Get.context!)}');
    print('Maghrib: ${maghrib.value.format(Get.context!)}');
    print('Isha: ${isha.value.format(Get.context!)}');
  }
}
