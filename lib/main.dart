import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:masjid_noor_customer/presentation/pages/app_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/order/order_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/user/user_controller.dart';
import 'package:masjid_noor_customer/presentation/theme/app_theme.dart';
import 'package:url_strategy/url_strategy.dart';

import 'mgr/dependency/supabase_dep.dart';
import 'navigation/router.dart';

import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('user_box'); // Open Hive box for storing user data
  setPathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  await SupabaseDep.impl.initialize();
  // if (Platform.isWindows) {
  // await windowManager.ensureInitialized();
  //   WindowManager.instance.setMinimumSize(const Size(390, 844));
  //   WindowManager.instance.setMaximumSize(const Size(390, 844));
  // }

  Get.lazyPut(() => UserController());
  Get.lazyPut(() => ProductController());
  Get.lazyPut(() => CartController());
  Get.lazyPut(() => OrderController());
  Get.lazyPut(() => AppController());

  runApp(AnNoorApp());
}

class AnNoorApp extends GetView<AppController> {
  AnNoorApp({super.key});

  final botToastBuilder = BotToastInit();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      enableScaleText: () {
        return true;
      },
      minTextAdapt: true,
      builder: (_, child) => SafeArea(
        child: GetMaterialApp.router(
          debugShowCheckedModeBanner: false,
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
