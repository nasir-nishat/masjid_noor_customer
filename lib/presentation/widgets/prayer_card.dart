import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:masjid_noor_customer/presentation/pages/prayer/prayer_time_controller.dart';

class PrayerTimeCard extends StatelessWidget {
  final PrayerTime prayerTime;

  const PrayerTimeCard({super.key, required this.prayerTime});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            prayerTime.name,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            prayerTime.time,
            style: TextStyle(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
