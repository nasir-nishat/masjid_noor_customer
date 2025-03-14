import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:masjid_noor_customer/app_updater.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'constants.dart';
import 'noor_app.dart';
import 'mgr/dependency/supabase_dep.dart';
import 'mgr/models/user_md.dart';
import 'navigation/router.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  if (kIsWeb) {
    // Web-specific initialization
  } else {
    await runZonedGuarded(() async {
      if (Constants.isKiosk) {
        mainKioskRunner();
      } else {
        mainRunner();
      }
    }, (error, stackTrace) {
      debugPrint('Caught Dart error: $error');
      debugPrint('Stack trace: $stackTrace');
      Constants.isKiosk == false
          ? showAppErrorDialog('An unexpected error occurred: $error')
          : null;
    });
  }
}

//This is for KIOSK app
void mainKioskRunner() async {
  debugPrint('Running Kiosk App');
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserMdAdapter());
  await Hive.openBox<UserMd>('user_box');
  setPathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  await SupabaseDep.impl.initialize();
  await Future.delayed(const Duration(seconds: 2));

  runApp(const AnNoorKioskApp());
}

//This is for Customer's Retail app
void mainRunner() async {
  debugPrint('Running Regular App');
  await dotenv.load(fileName: ".env");
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    showAppErrorDialog('An unexpected error occurred: ${details.exception}');
  };
  await Hive.initFlutter();
  Hive.registerAdapter(UserMdAdapter());
  await Hive.openBox<UserMd>('user_box');
  setPathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  await SupabaseDep.impl.initialize();
  await Future.delayed(const Duration(seconds: 2));

  runApp(AnNoorApp());
}
