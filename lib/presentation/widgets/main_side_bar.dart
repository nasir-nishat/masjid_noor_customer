// ignore_for_file: library_private_types_in_public_api
//
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_noor_customer/mgr/models/feedback_md.dart';
import 'package:masjid_noor_customer/mgr/services/api_service.dart';
import 'package:masjid_noor_customer/navigation/router.dart';
// import 'package:masjid_noor_customer/presentation/admin_pages/app_controller.dart';
// import 'package:masjid_noor_customer/presentation/admin_pages/widgets/tap_widget.dart';
import 'package:masjid_noor_customer/presentation/constants.dart';
// import 'package:masjid_noor_customer/presentation/layout/main_layout.dart';
import 'package:masjid_noor_customer/presentation/widgets/tap_widget.dart';

import '../../../mgr/dependency/supabase_dep.dart';

class _MainNavItem {
  final String title;
  final String route;
  final IconData? icon;

  const _MainNavItem({
    required this.title,
    required this.route,
    this.icon,
  });
}

class MainSidebar extends StatefulWidget {
  const MainSidebar({Key? key}) : super(key: key);

  @override
  State<MainSidebar> createState() => _MainSidebarState();
}

class _MainSidebarState extends State<MainSidebar> {
  final List<_MainNavItem> navItems = [
    const _MainNavItem(title: "Home", route: Routes.home),
    const _MainNavItem(title: "Category", route: Routes.category),
    const _MainNavItem(title: "Products", route: Routes.products),
    const _MainNavItem(title: "Inventory", route: Routes.inventory),
    const _MainNavItem(title: "Order", route: Routes.orders),
    // const _MainNavItem(title: "Payment", route: Routes.payment),
  ];

  final List<_MainNavItem> navItemsFooter = [
    // //support with icon
    // const _MainNavItem(
    //     title: "Support", icon: Icons.headphones, route: ""), //todo: add route
    // //settings with icon
    // const _MainNavItem(
    //     title: "Settings",
    //     icon: Icons.settings_outlined,
    //     route: ""), //todo: add route
    // //logout with icon
    const _MainNavItem(
        title: "Report/Feedback",
        icon: Icons.report_gmailerrorred_rounded,
        route: ""),
    const _MainNavItem(title: "Logout", icon: Icons.logout, route: ""),
    //todo: add route
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10.0,
        bottom: 10.0,
        right: 10.0,
        left: MediaQuery.of(context).size.width > 800 ? 0.0 : 10.0,
      ),
      child: Container(
        width: 230,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(color: Colors.grey.shade300)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _getHeader(),
                ...navItems.map((e) => _buildNavItem(e.title, e.route)),
              ],
            ),
            _getFooter(),
          ],
        ),
      ),
    );
  }

  Widget _getHeader() {
    return TapWidget(
      onTap: () {
        if (GoRouterState.of(context).matchedLocation != Routes.home) {
          context.go(Routes.home);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        // child: SvgPicture.asset(Assets.cgLogoFull),
        // child: SvgPicture.asset(
        //   "assets/icons/svg/moon.svg",
        //   height: 40.0,
        // ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/favicon.png",
              height: 40.0,
            ),
            const SizedBox(width: 10.0),
            Text(
              "Masjid Noor",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getFooter() {
    Widget getLoggedInUser() {
      final user = SupabaseDep.impl.auth.currentUser;
      final firstName = user?.userMetadata?["first_name"];
      final lastName = user?.userMetadata?["last_name"];
      if (user != null) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    "${firstName.toString().characters.first}${lastName.toString().characters.first}",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 10.0),
                SizedBox(
                  width: 140.0,
                  child: Text(user.email!,
                      softWrap: true,
                      maxLines: 2,
                      style: context.textTheme.labelSmall),
                ),
              ],
            ),
            const Text("Version: ${Constants.version}"),
          ],
        );
      } else {
        return const SizedBox();
      }
    }

    Widget buildFooterNavItem(String title, IconData icon) {
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        title: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w600, color: Color(0xFF444656)),
        ),
        horizontalTitleGap: 3,
        onTap: () async {
          if (title == "Report/Feedback") {
            final bool? prompt = await showDialog(
                useRootNavigator: false,
                context: context,
                builder: (context) {
                  TextEditingController feedbackController =
                      TextEditingController();
                  return AlertDialog(
                    title: const Text("Report/Feedback"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                            "Do you want to report a bug or give feedback?"),
                        const SizedBox(height: 10.0),
                        TextField(
                          controller: feedbackController,
                          decoration: const InputDecoration(
                              hintText: "Enter your feedback here"),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => context.pop(false),
                          child: const Text("Cancel")),
                      TextButton(
                          onPressed: () async {
                            FeedbackMd feedback = FeedbackMd(
                              feedback: feedbackController.text,
                              rating: 0,
                            );

                            bool isDone =
                                await ApiService().sendFeedback(feedback);
                            if (isDone) {
                              feedbackController.dispose();
                              // ignore: use_build_context_synchronously
                              context.pop(true);
                            }
                          },
                          child: const Text("Report/Feedback")),
                    ],
                  );
                });
            if (prompt == true) {
              // ignore: use_build_context_synchronously
              showSnackBar(context, "Feedback sent successfully");
            }
          }

          if (title == "Logout") {
            final bool? prompt = await showDialog(
                useRootNavigator: false,
                // ignore: use_build_context_synchronously
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                            onPressed: () => context.pop(false),
                            child: const Text("Cancel")),
                        TextButton(
                            onPressed: () async {
                              await AuthenticationNotifier.instance.logout();
                              if (context.mounted) {
                                context.go(Routes.login);
                                context.pop(true);
                              }
                            },
                            child: const Text("Logout")),
                      ],
                    ));
            if (prompt == true) {
              // ignore: use_build_context_synchronously
              await AuthenticationNotifier.instance.logout();
              context.go(Routes.login);
            }
          }
        },
        leading: Icon(icon,
            size: 22,
            color: Theme.of(context).colorScheme.primary.withOpacity(.7)),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //logged in user
          getLoggedInUser(),
          const SizedBox(height: 20.0),
          //Navigation
          ...navItemsFooter.map((e) => buildFooterNavItem(e.title, e.icon!)),
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldState> drawerKey = GlobalKey(); // Create a key

  Widget _buildNavItem(String title, String route) {
    bool isSelected = route == GoRouterState.of(context).matchedLocation;
    return ListTile(
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.primary,
      onTap: () {
        if (route.isEmpty) return;
        context.go(route);
        if (MediaQuery.of(context).size.width < 800) {
          drawerKey.currentState!.closeDrawer();
        }
      },
      title: Text(title,
          style: TextStyle(
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF1B2A70)
                  : const Color.fromARGB(255, 19, 24, 44))),
      trailing: const Icon(Icons.keyboard_arrow_right),
      style: ListTileStyle.drawer,
    );
  }
}
