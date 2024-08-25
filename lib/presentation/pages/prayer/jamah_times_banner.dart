import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_noor_customer/presentation/pages/prayer/prayer_time_controller.dart';
import 'package:shimmer/shimmer.dart';
import '../../../mgr/models/jamah_md.dart';
import '../../../navigation/router.dart';
import '../../widgets/spaced_column.dart';
import '../../widgets/spaced_row.dart';

class JamahTimesBanner extends StatefulWidget {
  const JamahTimesBanner({super.key});

  @override
  JamahTimesBannerState createState() => JamahTimesBannerState();
}

class JamahTimesBannerState extends State<JamahTimesBanner> {
  final PageController _pageController = PageController(initialPage: 0);
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    PrayerTimesController.to.getJamah();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(seconds: 1),
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<PrayerTimesController>();
      if (controller.jamahs.isEmpty) {
        return _buildLoadingShimmer();
      } else {
        return GestureDetector(
          onTap: () {
            context.push(Routes.jamahTimes);
          },
          child: PageView.builder(
            controller: _pageController,
            itemBuilder: (context, index) {
              int actualIndex = index % controller.jamahs.length;
              JamahMd jamah = controller.jamahs[actualIndex];
              return _buildBanner(jamah, context);
            },
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        );
      }
    });
  }

  Widget _buildBanner(JamahMd jamah, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: context.theme.primaryColor.withOpacity(0.1),
          ),
          // color: Colors.teal.withOpacity(0.03),
          color: context.theme.primaryColor.withOpacity(0.03),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeader(jamah.spotName, jamah.spotLocation),
              _buildPrayerTimes(jamah, context),
              if (jamah.otherJamah != null && jamah.otherJamah!.isNotEmpty)
                Container(
                  color: Colors.grey.shade300,
                  height: 1.h,
                  width: double.infinity,
                ),
              if (jamah.otherJamah != null && jamah.otherJamah!.isNotEmpty)
                _buildAdditionalPrayers(jamah.otherJamah!, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String spotName, String spotLocation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          spotName,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerTimes(JamahMd jamah, BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPrayerTimeRow('Fajr', jamah.fajr, context),
          _buildPrayerTimeRow('Dhuhr', jamah.duhr, context),
          _buildPrayerTimeRow('Asr', jamah.asr, context),
          _buildPrayerTimeRow('Maghrib', jamah.magrib, context),
          _buildPrayerTimeRow('Isha', jamah.isha, context),
        ],
      ),
    );
  }

  Widget _buildPrayerTimeRow(
      String prayerName, TimeOfDay? time, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prayerName,
            style: TextStyle(
              fontSize: 12.sp,
            ),
          ),
          Text(
            time != null ? time.format(context) : 'N/A',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.teal.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalPrayers(
      List<Map<String, dynamic>> otherJamah, BuildContext context) {
    return SpacedRow(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      horizontalSpace: 20.w,
      children: otherJamah.map((j) {
        TimeOfDay time = TimeOfDay(
          hour: int.parse(j['time'].split(':')[0]),
          minute: int.parse(j['time'].split(':')[1]),
        );
        return Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: SpacedColumn(
            // horizontalSpace: 10.w,
            children: [
              Text(
                j['name'] ?? '',
                style: TextStyle(
                  fontSize: 12.sp,
                ),
              ),
              Text(
                time.format(context),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal.shade700,
                ),
              ),
            ],
          ),
        );
      }).toList(),
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
