import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';
import 'controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to An-Noor Kiosk',
              style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: () => Get.toNamed(KioskRoutes.KIOSK),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
                child: Text(
                  'Order Now',
                  style: TextStyle(fontSize: 24.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
