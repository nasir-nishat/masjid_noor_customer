import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:masjid_noor_customer/presentation/layout/error_layout.dart';
import 'package:masjid_noor_customer/presentation/pages/app_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/internet/internet_binding.dart';
import 'package:masjid_noor_customer/presentation/theme/app_theme.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'constants.dart';
// import 'main_kiosk.dart';
import 'main_kiosk.dart';
import 'mgr/dependency/supabase_dep.dart';
import 'mgr/models/user_md.dart';
import 'mgr/services/network_service.dart';
import 'navigation/router.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      showAppErrorDialog('An unexpected error occurred: ${details.exception}');
    };
    if (Constants.isKiosk) {
      runApp(const AnNoorKioskApp());
      return;
    }
    await Hive.initFlutter();
    Hive.registerAdapter(UserMdAdapter());
    await Hive.openBox<UserMd>('user_box');

    setPathUrlStrategy();
    GoRouter.optionURLReflectsImperativeAPIs = true;
    await SupabaseDep.impl.initialize();
    await Future.delayed(const Duration(seconds: 2));

    runApp(AnNoorApp());
  }, (error, stackTrace) {
    debugPrint('Caught Dart error: $error');
    debugPrint('Stack trace: $stackTrace');
    showAppErrorDialog('An unexpected error occurred: $error');
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
      builder: (_, child) => PopScope(
        canPop: false,
        child: SafeArea(
          child: GetMaterialApp.router(
            initialBinding: InitialBindings(),
            debugShowCheckedModeBanner: false,
            theme: AppTheme.defaultTheme,
            routeInformationParser: goRouter.routeInformationParser,
            routeInformationProvider: goRouter.routeInformationProvider,
            routerDelegate: goRouter.routerDelegate,
            backButtonDispatcher: goRouter.backButtonDispatcher,
            builder: (context, child) {
              child = botToastBuilder(context, child);
              return NetworkAwareWidget(
                networkService: NetworkService(),
                child: Stack(
                  children: [
                    ErrorBoundary(child: child),
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
