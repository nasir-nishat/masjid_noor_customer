import 'dart:async';

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
import 'mgr/models/user_md.dart';
import 'navigation/router.dart';

void main() async {
  // Ensure everything is initialized in the same zone
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    Hive.registerAdapter(UserMdAdapter());
    await Hive.openBox<UserMd>('user_box');

    setPathUrlStrategy();
    GoRouter.optionURLReflectsImperativeAPIs = true;
    await SupabaseDep.impl.initialize();

    Get.lazyPut(() => UserController());
    Get.lazyPut(() => ProductController());
    Get.lazyPut(() => CartController());
    Get.lazyPut(() => OrderController());
    Get.lazyPut(() => AppController());

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      AppController.to.showErrorDialog(details.exceptionAsString());
    };

    runApp(AnNoorApp());
  }, (error, stackTrace) {
    print('Caught Dart error: $error');
    AppController.to.showErrorDialog(error.toString());
  });
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
            AppController.to.setGlobalContext(context);
            return Stack(
              children: [
                child!,
                Obx(() {
                  if (AppController.to.globalLoading.value) {
                    return Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
