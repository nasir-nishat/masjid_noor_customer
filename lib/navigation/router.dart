import 'package:go_router/go_router.dart';
import 'package:masjid_noor_customer/presentation/layout/authentic_layout.dart';
import 'package:masjid_noor_customer/presentation/layout/main_layout.dart';

import '../mgr/dependency/supabase_dep.dart';
import '../mgr/models/user_md.dart';
import '../mgr/services/api_service.dart';
import '../presentation/pages/all_export.dart';
import '../presentation/pages/user/forgot_pass_page.dart';
import '../presentation/pages/user/sign_up_page.dart';
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

  Future<Result> logout() async {
    return await SupabaseDep.impl.auth
        .signOut(scope: SignOutScope.global)
        .wait();
  }
}

final GoRouter goRouter = GoRouter(
  initialLocation: Routes.home,
  debugLogDiagnostics: true,
  observers: [
    BotToastNavigatorObserver(),
  ],
  routes: <RouteBase>[
    GoRoute(
      path: "/",
      redirect: (_, __) => Routes.home,
    ),
    GoRoute(
      path: '/login-callback',
      builder: (context, state) {
        print("Redirect URI: ${state}");
        SupabaseDep.impl.auth
            .getSessionFromUrl(Uri.parse(state.toString()))
            .then((session) {
          print("Session: $session");
          if (session != null) {
            context.go('/home'); // Navigate to home page
          } else {
            context.go('/login'); // Navigate back to login page
          }
        }).catchError((e) {
          print("Error processing auth redirect: $e");
          context.go('/login'); // Navigate back to login page
        });
        return const CircularProgressIndicator(); // Show a loading page while processing
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: Routes.home,
          pageBuilder: (context, state) {
            return NoTransitionPage(child: HomePage());
          },
        ),
        GoRoute(
          path: Routes.search,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: SearchPage(),
            );
          },
        ),
        GoRoute(
          path: Routes.profile,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: ProfilePage(),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: Routes.cart,
      pageBuilder: (context, state) {
        return const NoTransitionPage(
          child: CartPage(),
        );
      },
    ),
    GoRoute(
      path: Routes.products,
      pageBuilder: (context, state) {
        return const NoTransitionPage(
          child: ProductListPage(),
        );
      },
    ),
    GoRoute(
      path: "${Routes.productDetails}/:id",
      pageBuilder: (context, state) {
        Map ext = state.extra as Map;
        return NoTransitionPage(
          child: ProductDetailsPage(
              id: ext['id'], parentRoute: ext['parentRoute']),
        );
      },
    ),
    GoRoute(
      path: Routes.signup,
      pageBuilder: (context, state) {
        return NoTransitionPage(
          child: SignupPage(),
        );
      },
    ),
    GoRoute(
      path: Routes.forgotPassword,
      pageBuilder: (context, state) {
        return NoTransitionPage(
          child: ForgotPasswordPage(),
        );
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return AuthenticationLayout(child: child);
      },
      routes: [
        GoRoute(
          path: Routes.login,
          redirect: (_, __) async {
            return AuthenticationNotifier.instance.isLoggedIn
                ? Routes.profile
                : null;
          },
          pageBuilder: (context, state) {
            return defaultTransition(
                child: LoginPage(), routeName: Routes.login);
          },
        ),
      ],
    ),
  ],
);

CustomTransitionPage defaultTransition(
    {required Widget child, required String routeName}) {
  return CustomTransitionPage(
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // return FadeTransition(
        //   opacity: animation,
        //   child: child,
        // );

        final tween =
            Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
        final curveTween = CurveTween(curve: Curves.easeInOut);
        final animation1 = animation.drive(curveTween);

        return SlideTransition(
          position: tween.animate(animation1),
          child: child,
        );
      });
}

abstract class Routes {
  static const login = '/login';
  static const home = '/home';
  static const category = '/category';
  static const products = '/products';
  static const productDetails = '/product/details';
  static const order = '/order';
  static const payment = '/payment';
  static const inventory = '/inventory';
  static const profile = '/profile';

  static const productCreate = '/create';
  static const forgotPassword = '/forgot-password';

  static const cart = '/cart';
  static const search = '/search';
  static const signup = '/sign-up';

  static const all = {
    login,
    inventory,
    order,
    home,
    products,
    productDetails,
    payment,
    productCreate,
    forgotPassword,
    profile,
    cart,
    search,
    signup,
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
    {Duration duration = const Duration(milliseconds: 300)}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
    ),
  );
}
