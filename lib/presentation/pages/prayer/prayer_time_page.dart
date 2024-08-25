import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_noor_customer/presentation/pages/prayer/prayer_time_controller.dart';
import 'package:masjid_noor_customer/presentation/widgets/prayer_card.dart';
import 'package:shimmer/shimmer.dart';
import '../../../navigation/router.dart';

class PrayerTimesBanner extends StatefulWidget {
  const PrayerTimesBanner({super.key});

  @override
  PrayerTimesBannerState createState() => PrayerTimesBannerState();
}

class PrayerTimesBannerState extends State<PrayerTimesBanner> {
  final controller = Get.find<PrayerTimesController>();

  @override
  void initState() {
    super.initState();
    if (controller.currentPosition.value == null) {
      controller.getCurrentLocation(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingShimmer();
      }

      if (controller.error.isNotEmpty) {
        return Center(child: Text(controller.error.value));
      }

      if (controller.currentPosition.value == null) {
        return _buildLocationPrompt();
      }

      return GestureDetector(
        onTap: () {
          context.push(Routes.jamahTimes);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: context.theme.primaryColor.withOpacity(0.5),
            ),
            color: context.theme.primaryColor.withOpacity(0.05),
          ),
          padding: EdgeInsets.all(8.r),
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.prayerTimes.length,
            itemBuilder: (context, index) {
              final prayerTime = controller.prayerTimes[index];
              return PrayerTimeCard(prayerTime: prayerTime);
            },
          ),
        ),
      );
    });
  }

  Widget _buildLocationPrompt() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          border:
              Border.all(color: context.theme.primaryColor.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8.r),
          color: context.theme.primaryColor
              .withOpacity(0.05), // Light background color
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_off,
                  size: 18.sp,
                  color: Colors.redAccent,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Location Services Disabled',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'Please enable location services to show the prayer times.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              'If you have disabled location services permanently, please go to your device settings to enable it.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10.sp, color: Colors.redAccent),
            ),
            SizedBox(height: 8.h),
            TextButton.icon(
              onPressed: () async {
                // Try to get the current location, if it fails, navigate to settings
                final locationEnabled =
                    await controller.getCurrentLocation(context);
                if (!locationEnabled) {
                  await controller.openAppSettings();
                }
              },
              icon: Icon(Icons.location_on,
                  size: 14.sp, color: context.theme.primaryColor),
              label: Text(
                'Enable Location',
                style: TextStyle(
                    fontSize: 10.sp, color: context.theme.primaryColor),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                backgroundColor: context.theme.primaryColor
                    .withOpacity(0.1), // Light primary color background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: context.theme.primaryColor.withOpacity(0.5),
          ),
          color: context.theme.primaryColor,
        ),
        height: 80,
      ),
    );
  }
}
