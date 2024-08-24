import 'package:google_sign_in/google_sign_in.dart';
import 'package:masjid_noor_customer/presentation/layout/authentic_layout.dart';
import 'package:masjid_noor_customer/presentation/layout/main_layout.dart';
import 'package:masjid_noor_customer/presentation/pages/order/orders_page.dart';
import 'package:masjid_noor_customer/presentation/pages/prayer/jamah_times_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../presentation/pages/all_export.dart';
import '../presentation/pages/cart/barcode_scanner.dart';
import '../presentation/pages/cart/cart_page_v2.dart';
import '../presentation/pages/user/privacy_policy.dart';
import '../presentation/utills/extensions.dart';

class AuthenticationNotifier {
  static final AuthenticationNotifier _authenticationNotifier =
      AuthenticationNotifier._internal();

  factory AuthenticationNotifier() {
    return _authenticationNotifier;
  }

  AuthenticationNotifier._internal();

  static AuthenticationNotifier get instance => _authenticationNotifier;

  final Box<UserMd> _userBox = Hive.box<UserMd>('user_box');

  Stream<AuthState> get userStream => SupabaseDep.impl.auth.onAuthStateChange;

  bool get isLoggedIn => SupabaseDep.impl.currentUser != null;

  UserMd? get usermd => _userBox.get('user');

  set usermd(UserMd? user) {
    if (user != null) {
      _userBox.put('user', user);
    }
  }

  Future<Result> logout() async {
    return await SupabaseDep.impl.auth
        .signOut(scope: SignOutScope.global)
        .wait();
  }

  Future<AuthResponse> googleSignIn() async {
    const webClientId = GOOGLE_WEB_CLIENT_ID;
    // TODO: Add IOS
    // const iosClientId = 'my-ios.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    final authResponse = await SupabaseDep.impl.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    // UserMd userLog = UserMd(
    //   userId: authResponse.user!.id,
    //   email: authResponse.user!.userMetadata!["email"],
    //   passwordHash: '',
    //   phoneNumber: '',
    //   createdAt: DateTime.now(),
    //   firstName: authResponse.user!.userMetadata!["full_name"]
    //       .toString()
    //       .split(' ')[0],
    //   lastName: authResponse.user!.userMetadata!["full_name"]
    //       .toString()
    //       .split(' ')[1],
    //   username:
    //       authResponse.user!.userMetadata!["email"].toString().split('@')[0],
    //   profilePic: authResponse.user!.userMetadata!["avatar_url"],
    // );

    UserMd? curUserMd = await ApiService().getUser(authResponse.user!.id);
    if (curUserMd != null) {
      usermd = curUserMd;
    } else {
      await ApiService().registerUser(usermd!);
    }

    _userBox.put('user', usermd!);

    return authResponse;
  }
}

String getCurrentRoute(BuildContext context) {
  String currentPath = GoRouter.of(context)
      .routerDelegate
      .currentConfiguration
      .last
      .route
      .path
      .toString();

  switch (currentPath) {
    case var path when path.contains(Routes.productDetails):
      return Routes.productDetails;
    case var path when path.contains(Routes.products):
      return Routes.products;
    case var path when path.contains(Routes.home):
      return Routes.home;
    case var path when path.contains(Routes.search):
      return Routes.search;
    case var path when path.contains(Routes.profile):
      return Routes.profile;
    default:
      return "";
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
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          onExit: (context, state) async {
            final shouldExit = await _showExitConfirmationDialog(context);
            if (shouldExit == true) {
              return true;
            } else {
              return false;
            }
          },
          path: Routes.home,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
                child: PopScope(canPop: false, child: HomePage()));
          },
        ),
        GoRoute(
          path: Routes.products,
          pageBuilder: (context, state) {
            return NoTransitionPage(
              child: ProductListPage(),
            );
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
        GoRoute(
          path: Routes.privacyPolicy,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: PrivacyPolicy(),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: Routes.orders,
      pageBuilder: (context, state) {
        return const NoTransitionPage(
          child: OrdersPage(),
        );
      },
    ),
    GoRoute(
      path: Routes.jamahTimes,
      pageBuilder: (context, state) {
        return const NoTransitionPage(
          child: JamahTimesPage(),
        );
      },
    ),
    GoRoute(
      path: Routes.cart,
      pageBuilder: (context, state) {
        return const NoTransitionPage(
          // child: CartPage(),
          child: CartPageV2(),
        );
      },
    ),
    GoRoute(
      path: Routes.barcodeScanner,
      pageBuilder: (context, state) {
        return const NoTransitionPage(
          child: BarcodeScannerSimple(),
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
                child: const LoginPage(), routeName: Routes.login);
          },
        ),
      ],
    ),
  ],
);

Future<bool?> _showExitConfirmationDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Exit'),
        content: const Text('Are you sure you want to exit?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // User confirms exit
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // User cancels exit
            },
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}

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
  static const orders = '/profile/orders';
  static const payment = '/payment';
  static const inventory = '/inventory';
  static const profile = '/profile';
  static const jamahTimes = '/jamah-times';
  static const privacyPolicy = '/privacy-policy';

  static const productCreate = '/create';
  static const forgotPassword = '/forgot-password';

  static const cart = '/cart';
  static const search = '/search';
  static const signup = '/sign-up';
  static const barcodeScanner = '/barcode-scanner';
  static const all = {
    login,
    inventory,
    orders,
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
    jamahTimes,
    barcodeScanner,
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

void showToast(String message, {bool isSuccess = true, bool? isWarning}) {
  BotToast.showText(
    text: message,
    textStyle: TextStyle(
        color: isWarning == true ? Colors.black : Colors.white,
        fontWeight: FontWeight.bold),
    duration: const Duration(seconds: 2),
    contentColor: (isWarning == true)
        ? Colors.yellow.shade400
        : isSuccess
            ? Colors.green
            : Colors.red,
  );
}

void showErrorDialog(String message,
    {Function(CancelFunc)? onClose, bool isSuccess = false}) {
  BotToast.showEnhancedWidget(
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
