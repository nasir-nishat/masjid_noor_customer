// ignore_for_file: use_build_context_synchronously

import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:masjid_noor_customer/mgr/dependency/supabase_dep.dart';
import 'package:masjid_noor_customer/mgr/models/user_md.dart';
import 'package:masjid_noor_customer/mgr/services/api_service.dart';
import 'package:masjid_noor_customer/presentation/pages/all_export.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final supabase = Supabase.instance.client;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  bool isLoading = false;
  String errorMessage = '';
  bool phoneNumDone = false;
  PhoneInputFormatter phoneFormatter = PhoneInputFormatter();
  TextEditingController phoneController = TextEditingController();

  String userToken = '';
  UserMd? usermd;

  @override
  void initState() {
    _setupAuthListener();
    super.initState();
  }

  void _setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Routes.goToHomePage(context);
      }
    });
  }

  Future<AuthResponse> _googleSignIn() async {
    const webClientId = GOOGLE_WEB_CLIENT_ID;

    const iosClientId = 'my-ios.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
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

    setState(() {
      userToken = idToken;
      usermd = UserMd(
        email: googleUser.email,
        passwordHash: '',
        phoneNumber: phoneController.text,
        createdAt: DateTime.now(),
        firstName: googleUser.displayName?.split(' ')[0],
        lastName: googleUser.displayName?.split(' ')[1],
      );
    });
    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/favicon.png',
                width: 100.0,
                height: 100.0,
              ),
              const SizedBox(height: 30.0),
              Container(
                width: 400.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Login',
                          style: TextStyle(fontSize: 30.0),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          "السلام عليكم و رحمة الله و بركاته\n",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(height: 10.0),
                        if (!phoneNumDone)
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone number',
                              hintText: 'Enter your phone number',
                            ),
                            inputFormatters: [
                              PhoneInputFormatter(
                                allowEndlessPhone: false,
                                defaultCountryCode: 'KR',
                              )
                            ],
                          ),
                        if (!phoneNumDone) const SizedBox(height: 10.0),
                        if (!phoneNumDone)
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  phoneNumDone = true;
                                });
                              },
                              child: const Text('Next')),
                        if (phoneNumDone)
                          ElevatedButton.icon(
                            icon: Image.asset(
                              'assets/google_logo.png',
                              width: 24,
                            ),
                            onPressed: () async {
                              _googleSignIn();
                              if (usermd != null && userToken.isNotEmpty) {
                                print("OREEE");
                                AuthenticationNotifier().login(
                                  idToken: userToken,
                                  usermd: usermd!,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              foregroundColor: Colors.black,
                              minimumSize: const Size(326, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: const BorderSide(
                                    color: Colors.black, width: 1),
                              ),
                            ),
                            label: const Text('Log in with Gmail'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}
