import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masjid_noor_customer/presentation/theme/app_theme.dart';
import 'package:get/get.dart';
import 'kiosk/routes/app_pages.dart';
import 'package:masjid_noor_customer/presentation/layout/error_layout.dart';
import 'package:masjid_noor_customer/presentation/pages/app_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/internet/internet_binding.dart';
import 'package:bot_toast/bot_toast.dart';
import 'mgr/services/network_service.dart';
import 'navigation/router.dart';

class AnNoorKioskApp extends StatelessWidget {
  const AnNoorKioskApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    _setImmersiveMode();

    return MaterialApp(
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: ScreenUtilInit(
        designSize: const Size(860, 395),
        builder: (_, child) => NetworkAwareWidget(
          networkService: NetworkService(),
          child: GetMaterialApp(
            initialBinding: InitialBindings(),
            debugShowCheckedModeBanner: false,
            theme: AppTheme.defaultTheme.copyWith(
              scaffoldBackgroundColor: Colors.white,
            ),
            initialRoute: KioskAppPages.INITIAL,
            getPages: KioskAppPages.kioskRoutes,
          ),
        ),
      ),
    );
  }

  void _setImmersiveMode() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [
        SystemUiOverlay.bottom,
        SystemUiOverlay.top,
      ],
    );
  }
}

//This is for Customer's Retail app
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
