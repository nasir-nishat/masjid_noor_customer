import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masjid_noor_customer/presentation/theme/app_theme.dart';
import 'package:get/get.dart';

import 'kiosk/routes/app_pages.dart';

class AnNoorKioskApp extends StatelessWidget {
  AnNoorKioskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      builder: (_, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.defaultTheme.copyWith(
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: KioskAppPages.INITIAL,
        getPages: KioskAppPages.kioskRoutes,
      ),
    );
  }
}
