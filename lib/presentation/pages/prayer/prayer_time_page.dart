import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:masjid_noor_customer/presentation/pages/prayer/prayer_time_controller.dart';
import 'package:masjid_noor_customer/presentation/widgets/spaced_column.dart';

class PrayerTimes extends GetView<PrayerTimesController> {
  const PrayerTimes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              controller.savePrayerTimes();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          verticalSpace: 20.h,
          children: [
            _buildTimePicker(context, 'Fajr', controller.fajr),
            _buildTimePicker(context, 'Dhuhr', controller.dhuhr),
            _buildTimePicker(context, 'Asr', controller.asr),
            _buildTimePicker(context, 'Maghrib', controller.maghrib),
            _buildTimePicker(context, 'Isha', controller.isha),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(
      BuildContext context, String prayer, Rx<TimeOfDay> time) {
    return Obx(() {
      return ListTile(
        title: Text(prayer),
        trailing: Text(time.value.format(context)),
        onTap: () async {
          TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: time.value,
          );
          if (picked != null && picked != time.value) {
            controller.setTime(prayer, picked);
          }
        },
      );
    });
  }
}
