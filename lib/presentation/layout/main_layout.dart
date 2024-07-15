import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:masjid_noor_customer/mgr/dependency/supabase_dep.dart';
import 'package:masjid_noor_customer/navigation/router.dart';
import 'package:masjid_noor_customer/presentation/pages/app_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/user/user_controller.dart';

import '../widgets/header.dart';

final GlobalKey<ScaffoldState> drawerKey = GlobalKey();

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool get loggedIn => SupabaseDep.impl.auth.currentUser != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 5.w,
          ),
          child: Header(currentRoute: getCurrentRoute(context)),
        ),
      ),
      body: Padding(padding: EdgeInsets.all(10.w), child: widget.child),
      bottomNavigationBar: showBottomNav(context)
          ? BottomNavigationBar(
              selectedFontSize: 0,
              currentIndex: getCurrentIndex(context),
              useLegacyColorScheme: false,
              onTap: (index) {
                _onItemTapped(index, context);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: HeroIcon(HeroIcons.home),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: HeroIcon(HeroIcons.shoppingBag),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: HeroIcon(HeroIcons.magnifyingGlass),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: HeroIcon(HeroIcons.user),
                  label: '',
                ),
              ],
            )
          : null,
    );
  }

  int getCurrentIndex(BuildContext context) {
    String currentRoute = getCurrentRoute(context);

    switch (currentRoute) {
      case Routes.home:
        return 0;
      case Routes.products:
        return 1;
      case Routes.search:
        return 2;
      case Routes.profile:
        return 3;
      default:
        return 0;
    }
  }

  void _onItemTapped(int index, BuildContext context) {
    String currentRoute = getCurrentRoute(context);
    switch (index) {
      case 0:
        if (currentRoute != Routes.home) {
          // AppController.to.currentRoute.value = Routes.home;
          context.go(Routes.home);
        }
        break;
      case 1:
        if (currentRoute != Routes.products) {
          // AppController.to.currentRoute.value = Routes.products;
          context.go(Routes.products);
        }
        break;
      case 2:
        if (currentRoute != Routes.search) {
          // AppController.to.currentRoute.value = Routes.search;
          context.go(Routes.search);
        }
        break;
      case 3:
        if (currentRoute != Routes.profile) {
          if (loggedIn) {
            UserController.to.fetchUser();
            // AppController.to.currentRoute.value = Routes.profile;
            context.go(Routes.profile);
          } else {
            context.push(Routes.login);
          }
        }
        break;
    }
  }

  bool showBottomNav(BuildContext context) {
    String currentRoute = getCurrentRoute(context);
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
