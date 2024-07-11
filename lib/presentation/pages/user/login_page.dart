// ignore_for_file: use_build_context_synchronously

import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:masjid_noor_customer/mgr/dependency/supabase_dep.dart';
import 'package:masjid_noor_customer/mgr/models/user_md.dart';
import 'package:masjid_noor_customer/mgr/services/api_service.dart';
import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
  TextEditingController phoneController = TextEditingController();

  String userToken = '';
  UserMd? usermd;

  bool isBtnEnabled = false;

  @override
  void initState() {
    // _setupAuthListener();
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

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
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
                            decoration: InputDecoration(
                              labelText: 'Phone number',
                              hintText: '010 0000 0000',
                              prefix: Text('+82 ',
                                  style: TextStyle(
                                      fontSize: 16.sp, color: Colors.black)),
                            ),
                            inputFormatters: [
                              MaskTextInputFormatter(
                                  mask: '### #### ####',
                                  filter: {"#": RegExp(r'[0-9]')})
                            ],
                          ),
                        if (!phoneNumDone) const SizedBox(height: 10.0),
                        if (!phoneNumDone)
                          ElevatedButton(
                              onPressed: () {
                                if (phoneController.text.isEmpty ||
                                    phoneController.text.length != 13) {
                                  return showSnackBar(
                                      context, 'Invalid phone number');
                                }
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
                              AuthResponse auth = await _googleSignIn();

                              usermd = UserMd(
                                userId: auth.user!.id,
                                email: auth.user!.userMetadata!["email"],
                                passwordHash: '',
                                phoneNumber: phoneController.text,
                                createdAt: DateTime.now(),
                                firstName: auth.user!.userMetadata!["full_name"]
                                    .toString()
                                    .split(' ')[0],
                                lastName: auth.user!.userMetadata!["full_name"]
                                    .toString()
                                    .split(' ')[1],
                                username: auth.user!.userMetadata!["email"]
                                    .toString()
                                    .split('@')[0],
                                profilePic:
                                    auth.user!.userMetadata!["avatar_url"],
                              );

                              UserMd user =
                                  await ApiService().registerUser(usermd!);
                              if (user.userId != null &&
                                  user.userId!.isNotEmpty) {
                                context.go(Routes.home);
                              } else {
                                showSnackBar(
                                    context, 'Failed to register user');
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
    });

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }
}
