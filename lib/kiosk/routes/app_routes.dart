// lib/app/routes/app_routes.dart
part of 'app_pages.dart';

abstract class KioskRoutes {
  KioskRoutes._();
  static const HOME = _Paths.HOME;
  static const KIOSK = _Paths.KIOSK;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/';
  static const KIOSK = '/kiosk';
}
