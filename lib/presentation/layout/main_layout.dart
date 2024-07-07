import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_noor_customer/mgr/dependency/supabase_dep.dart';
import 'package:masjid_noor_customer/navigation/router.dart';
import 'package:masjid_noor_customer/presentation/widgets/header.dart';
import 'package:masjid_noor_customer/presentation/widgets/main_side_bar.dart';

final GlobalKey<ScaffoldState> drawerKey = GlobalKey(); // Create a key

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final currentUser = SupabaseDep.impl.auth.currentUser;
      if (currentUser != null) {
        try {
          setState(() {
            loggedIn = true;
          });
        } catch (e) {
          await AuthenticationNotifier.instance.logout();
        }
      }
    });
  }

  bool loggedIn = true;

  String get currentRoute =>
      GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();

  @override
  Widget build(BuildContext context) {
    if (loggedIn) {
      return Scaffold(
        key: drawerKey,
        drawer: const MainSidebar(),
        body: Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            children: [
              Header(name: currentRoute.split('/').last.capitalize ?? ''),
              Expanded(
                child: widget.child,
              ),
            ],
          ),
        ),
      );
    } else {
      return const Material(child: SizedBox());
    }
  }
}
