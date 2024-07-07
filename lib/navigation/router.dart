import 'package:go_router/go_router.dart';
import 'package:masjid_noor_customer/presentation/layout/authentic_layout.dart';
import 'package:masjid_noor_customer/presentation/layout/main_layout.dart';

import '../mgr/dependency/supabase_dep.dart';
import '../presentation/pages/all_export.dart';
import '../presentation/utills/extensions.dart';

class AuthenticationNotifier {
  //Create a singleton
  static final AuthenticationNotifier _authenticationNotifier =
      AuthenticationNotifier._internal();

  factory AuthenticationNotifier() {
    return _authenticationNotifier;
  }

  AuthenticationNotifier._internal();

  static AuthenticationNotifier get instance => _authenticationNotifier;

  Stream<AuthState> get userStream => SupabaseDep.impl.auth.onAuthStateChange;

  bool get isLoggedIn => SupabaseDep.impl.currentUser != null;

  Future<Result> login(String email, String password) async {
    return await SupabaseDep.impl.auth
        .signInWithPassword(password: password, email: email)
        .wait();
  }

  Future<Result> logout() async {
    return await SupabaseDep.impl.auth.signOut().wait();
  }
}

final GoRouter goRouter = GoRouter(
  initialLocation: Routes.home,
  debugLogDiagnostics: true,
  observers: [
    BotToastNavigatorObserver(),
  ],
  redirect: (context, state) async {
    final bool isLoggedIn = AuthenticationNotifier.instance.isLoggedIn;
    return isLoggedIn ? null : Routes.home;
  },
  routes: <RouteBase>[
    GoRoute(
      path: "/",
      redirect: (_, __) => Routes.home,
    ),
    ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
              path: Routes.home,
              pageBuilder: (context, state) {
                return defaultTransition(
                    child: const HomePage(), routeName: Routes.home);
              }),
          GoRoute(
            path: Routes.product,
            pageBuilder: (context, state) {
              return defaultTransition(
                  child: const ProductListPage(), routeName: Routes.product);
            },
          ),
          GoRoute(
            path: Routes.productDetails,
            pageBuilder: (context, state) {
              return defaultTransition(
                  child: const ProductDetailsPage(),
                  routeName: Routes.productDetails);
            },
          ),
        ]),
    ShellRoute(
      builder: (context, state, child) {
        return AuthenticationLayout(child: child);
      },
      routes: [
        GoRoute(
            path: Routes.login,
            redirect: (_, __) async {
              // String? userEmail =
              //     SupabaseDep.impl.currentUser?.email.toString();
              // String userId = SupabaseDep.impl.currentUser?.id.toString() ?? "";
              // String userName =
              //     SupabaseDep.impl.currentUser?.userMetadata?["name"] ?? "";

              // //if the user is logged in with social, update the profile
              // if (userEmail != null && userEmail.isNotEmpty) {
              //   await Supabase.instance.client
              //       .from('profiles')
              //       .select()
              //       .eq('email', userEmail)
              //       .then((value) {
              //     if (value.isEmpty) {
              //       Supabase.instance.client.from('profiles').upsert([
              //         {'id': userId, 'username': userName, 'email': userEmail}
              //       ]).then((value) {
              //         return AuthenticationNotifier.instance.isLoggedIn
              //             ? Routes.home
              //             : null;
              //       });
              //     }
              //   });
              // }

              return AuthenticationNotifier.instance.isLoggedIn
                  ? Routes.profile
                  : null;
            },
            pageBuilder: (context, state) {
              return const NoTransitionPage(child: LoginPage());
            }),
      ],
    ),
    // ShellRoute(
    //   builder: (context, state, child) {
    //     return MainLayout(child: child);
    //   },
    //   routes: <GoRoute>[
    //     // GoRoute(
    //     //     path: Routes.order,
    //     //     pageBuilder: (context, state) {
    //     //       return defaultTransition(
    //     //           child: const OrderList(), routeName: Routes.order);
    //     //     }),
    //     // GoRoute(
    //     //     path: Routes.inventory,
    //     //     pageBuilder: (context, state) {
    //     //       return defaultTransition(
    //     //           child: const InventoryList(), routeName: Routes.inventory);
    //     //     }),
    //     // GoRoute(
    //     //     path: Routes.payment,
    //     //     pageBuilder: (context, state) {
    //     //       return defaultTransition(
    //     //           child: const PaymentList(), routeName: Routes.payment);
    //     //     }),
    //   ],
    // ),
  ],
);

CustomTransitionPage defaultTransition(
    {required Widget child, required String routeName}) {
  return CustomTransitionPage(
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      });
}

abstract class Routes {
  static const login = '/login';
  static const home = '/home';
  static const category = '/category';
  static const product = '/product';
  static const productDetails = '/details';
  static const order = '/order';
  static const payment = '/payment';
  static const inventory = '/inventory';
  static const profile = '/profile';

  static const productCreate = '/create';
  static const forgotPassword = '/forgot-password';

  static const all = {
    login,
    inventory,
    order,
    home,
    product,
    productDetails,
    payment,
    productCreate,
    forgotPassword,
    profile,
  };

  static void goToHomePage(BuildContext context) {
    context.go(Routes.home);
  }

  static CancelFunc showErrorDialog(String message,
      {Function(CancelFunc)? onClose, bool isSuccess = false}) {
    return BotToast.showEnhancedWidget(
        clickClose: false,
        allowClick: false,
        warpWidget: (cancelFunc, widget) {
          return MaterialApp(
            home: Container(
              color: Colors.grey.withOpacity(.7),
              child: widget,
            ),
          );
        },
        toastBuilder: (cancelFunc) {
          return AlertDialog(
            title: Text(isSuccess ? "Success" : 'Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  if (onClose == null) {
                    cancelFunc();
                  } else {
                    onClose(cancelFunc);
                  }
                },
                child: const Text('Close'),
              )
            ],
          );
        });
  }
}

void showSnackBar(BuildContext context, String message,
    {Duration duration = const Duration(seconds: 4)}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
    ),
  );
}
