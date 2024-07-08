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
  bool loggedIn = true;

  String get currentRoute =>
      GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(children: [
            Header(name: currentRoute),
            Expanded(
              child: widget.child,
            )
          ])),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final String location = currentRoute;
    if (location.startsWith(Routes.search)) {
      return 1;
    }
    if (location.startsWith(Routes.cart)) {
      return 2;
    }
    if (location.startsWith(Routes.profile)) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        // context.go(Routes.home);
        print("Clearing and navigating to home");
        clearAndNavigate(Routes.home);
        break;
      case 1:
        context.go(Routes.search);
        break;
      case 2:
        context.go(Routes.cart);
        break;
      case 3:
        context.go(Routes.profile);
        break;
    }
  }
}
