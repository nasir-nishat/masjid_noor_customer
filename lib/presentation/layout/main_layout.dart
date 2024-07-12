import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_noor_customer/mgr/dependency/supabase_dep.dart';
import 'package:masjid_noor_customer/navigation/router.dart';
import 'package:masjid_noor_customer/presentation/pages/app_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/user/user_controller.dart';

final GlobalKey<ScaffoldState> drawerKey = GlobalKey();

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
              currentIndex: AppController.to.navIndex.value,
              onTap: (index) {
                _onItemTapped(index, context);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_outlined),
                  label: 'Mart',
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

  void _getSelectedIndex(BuildContext context) {
    final String location = currentRoute;

    if (location.startsWith(Routes.products)) {
      AppController.to.navIndex.value = 1;
    } else if (location.startsWith(Routes.search)) {
      AppController.to.navIndex.value = 2;
    } else if ((location == Routes.profile) && loggedIn) {
      AppController.to.navIndex.value = 3;
    } else {
      AppController.to.navIndex.value = 0;
    }
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        if (currentRoute != Routes.home) {
          AppController.to.navIndex.value = 0;
          context.go(Routes.home);
        }
        break;
      case 1:
        if (currentRoute != Routes.products) {
          AppController.to.navIndex.value = 1;
          context.go(Routes.products);
        }
        break;
      case 2:
        if (currentRoute != Routes.search) {
          AppController.to.navIndex.value = 2;
          context.go(Routes.search);
        }
        break;
      case 3:
        if (currentRoute != Routes.profile) {
          if (loggedIn) {
            UserController.to.fetchUser();
            AppController.to.navIndex.value = 3;
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
    } else if (currentRoute == Routes.products) {
      return true;
    }
    return false;
  }
}
