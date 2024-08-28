// lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import 'package:masjid_noor_customer/kiosk/bindings/home_binding.dart';
import 'package:masjid_noor_customer/kiosk/bindings/kiosk_binding.dart';
import '../views/home_view.dart';
import '../views/kiosk_view.dart';

part 'app_routes.dart';

class KioskAppPages {
  KioskAppPages._();

  static const INITIAL = KioskRoutes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.KIOSK,
      page: () => const KioskView(),
      binding: KioskBinding(),
    ),
  ];
}
