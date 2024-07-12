import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_noor_customer/mgr/dependency/supabase_dep.dart';
import 'package:masjid_noor_customer/navigation/router.dart';
import 'package:masjid_noor_customer/presentation/pages/user/user_controller.dart';
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
  bool get loggedIn => SupabaseDep.impl.auth.currentUser != null;

  String get currentRoute =>
      GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsets.all(10.w), child: widget.child),
      bottomNavigationBar: showBottomNav()
          ? BottomNavigationBar(
              currentIndex: _getSelectedIndex(context),
              onTap: (index) {
                _onItemTapped(index, context);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            )
          : null,
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final String location = currentRoute;
    print("location: $location");
    if (location.startsWith(Routes.search)) {
      return 1;
    }
    if ((location == Routes.profile) && loggedIn) {
      return 2;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        if (currentRoute != Routes.home) {
          context.go(Routes.home);
        }
        break;
      case 1:
        if (currentRoute != Routes.search) {
          context.go(Routes.search);
        }
        break;
      case 2:
        if (currentRoute != Routes.profile) {
          if (loggedIn) {
            UserController.to.fetchUser();
            context.go(Routes.profile);
          } else {
            context.push(Routes.login);
          }
        }
        break;
    }
  }

  bool showBottomNav() {
    if (currentRoute.contains(Routes.orders)) {
      return false;
    } else if (currentRoute.contains(Routes.home)) {
      return true;
    } else if (currentRoute.contains(Routes.search)) {
      return true;
    } else if (currentRoute == Routes.profile && loggedIn) {
      return true;
    }
    return false;
  }
}
