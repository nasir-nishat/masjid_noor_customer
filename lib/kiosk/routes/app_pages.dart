// lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import '../views/home_view.dart';
import '../views/kiosk_view.dart';

part 'app_routes.dart';

class KioskAppPages {
  KioskAppPages._();

  static const INITIAL = KioskRoutes.HOME;

  static final kioskRoutes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
    ),
    GetPage(
      name: _Paths.KIOSK,
      page: () => const KioskView(),
    ),
  ];
}
