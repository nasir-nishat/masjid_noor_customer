import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_noor_customer/presentation/pages/prayer/prayer_time_controller.dart';

// class PrayerTimesBanner extends GetView<PrayerTimesController> {
//   static PrayerTimesBanner get to => Get.find();
//
//   PrayerTimesBanner({super.key}) {
//     controller.fetchPrayerTimes(latitude: 21.4225, longitude: 39.8262);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (controller.isLoading.value) {
//         return const Center(child: CircularProgressIndicator());
//       }
//
//       if (controller.error.isNotEmpty) {
//         return Center(child: Text(controller.error.value));
//       }
//
//       return SizedBox(
//         height: 120,
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: controller.prayerTimes.length,
//           itemBuilder: (context, index) {
//             final prayerTime = controller.prayerTimes[index];
//             return PrayerTimeCard(prayerTime: prayerTime);
//           },
//         ),
//       );
//     });
//   }
// }

class PrayerTimesBanner extends StatefulWidget {
  const PrayerTimesBanner({super.key});

  @override
  _PrayerTimesBannerState createState() => _PrayerTimesBannerState();
}

class _PrayerTimesBannerState extends State<PrayerTimesBanner> {
  final controller = Get.find<PrayerTimesController>();

  @override
  void initState() {
    super.initState();
    controller.getCurrentPosition(context);
    // controller.fetchPrayerTimes(latitude: 21.4225, longitude: 39.8262);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.error.isNotEmpty) {
        return Center(child: Text(controller.error.value));
      }

      return SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.prayerTimes.length,
          itemBuilder: (context, index) {
            final prayerTime = controller.prayerTimes[index];
            return PrayerTimeCard(prayerTime: prayerTime);
          },
        ),
      );
    });
  }
}

class PrayerTimeCard extends StatelessWidget {
  final PrayerTime prayerTime;

  const PrayerTimeCard({super.key, required this.prayerTime});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Container(
        width: 120,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              prayerTime.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              prayerTime.time,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
