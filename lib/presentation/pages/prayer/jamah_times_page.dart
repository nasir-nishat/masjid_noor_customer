import 'package:flutter/material.dart';import 'package:get/get.dart';import 'package:flutter_screenutil/flutter_screenutil.dart';import 'package:masjid_noor_customer/presentation/pages/prayer/prayer_time_controller.dart';import '../../../mgr/models/jamah_md.dart';class JamahTimesPage extends GetView<PrayerTimesController> {  const JamahTimesPage({super.key});  @override  Widget build(BuildContext context) {    return Scaffold(      appBar: AppBar(        title: const Text('Jamah Times'),      ),      body: Obx(() {        if (controller.jamahs.isEmpty) {          return const Center(child: CircularProgressIndicator());        } else {          return ListView.builder(            itemCount: controller.jamahs.length,            itemBuilder: (context, index) {              JamahMd jamah = controller.jamahs[index];              return Card(                margin: EdgeInsets.all(16.w),                child: Padding(                  padding: EdgeInsets.all(16.w),                  child: Column(                    crossAxisAlignment: CrossAxisAlignment.start,                    children: [                      Text(                        jamah.spotName,                        style: TextStyle(                          fontSize: 20.sp,                          fontWeight: FontWeight.bold,                        ),                      ),                      SizedBox(height: 8.h),                      Text(jamah.spotLocation),                      SizedBox(height: 16.h),                      _buildPrayerTime('Fajr', jamah.fajr),                      _buildPrayerTime('Dhuhr', jamah.duhr),                      _buildPrayerTime('Asr', jamah.asr),                      _buildPrayerTime('Maghrib', jamah.magrib),                      _buildPrayerTime('Isha', jamah.isha),                      SizedBox(height: 5.h),                      if (jamah.juma != null && jamah.juma!.isNotEmpty)                        for (var juma in jamah.juma!) _buildJummahTimes(juma),                    ],                  ),                ),              );            },          );        }      }),    );  }  Widget _buildPrayerTime(String prayerName, TimeOfDay? time) {    return Padding(      padding: EdgeInsets.symmetric(vertical: 4.h),      child: Row(        mainAxisAlignment: MainAxisAlignment.spaceBetween,        children: [          Text(prayerName, style: const TextStyle(fontWeight: FontWeight.bold)),          // Text(time != null ? time.substring(0, time.length - 3) : 'N/A'),          Text(time != null ? '${time.hour}:${time.minute}' : 'N/A'),        ],      ),    );  }  Widget _buildJummahTimes(Map<String, dynamic> jummahTime) {    return Column(      children: [        Row(          mainAxisAlignment: MainAxisAlignment.spaceBetween,          children: [            Text(jummahTime['name'] ?? 'Jummah',                style: const TextStyle(fontWeight: FontWeight.bold)),            Text(jummahTime['time'] ?? 'N/A'),          ],        ),        SizedBox(height: 5.h),      ],    );  }}