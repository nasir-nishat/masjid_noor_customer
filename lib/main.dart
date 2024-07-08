import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:masjid_noor_customer/presentation/pages/app_controller.dart';
import 'package:masjid_noor_customer/presentation/theme/app_theme.dart';
import 'package:url_strategy/url_strategy.dart';

import 'mgr/dependency/supabase_dep.dart';
import 'navigation/router.dart';

import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  await SupabaseDep.impl.initialize();

  // Get.lazyPut(() => DashboardController());
  // Get.lazyPut(() => AppController());
  // Get.lazyPut(() => CategoryController());
  // Get.lazyPut(() => ProductController());
  // Get.lazyPut(() => OrderController());
  // Get.lazyPut(() => PaymentController());
  // Get.lazyPut(() => InventoryController());

  runApp(AnNoorApp());
}

class AnNoorApp extends GetView<AppController> {
  AnNoorApp({super.key});

  final botToastBuilder = BotToastInit();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, child) => SafeArea(
        child: GetMaterialApp.router(
          theme: AppTheme.defaultTheme,
          routeInformationParser: goRouter.routeInformationParser,
          routeInformationProvider: goRouter.routeInformationProvider,
          routerDelegate: goRouter.routerDelegate,
          backButtonDispatcher: goRouter.backButtonDispatcher,
          builder: (context, child) {
            return botToastBuilder(context, child);
          },
        ),
      ),
    );
  }
}
