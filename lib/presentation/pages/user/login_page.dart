import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();

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
              context.go(Routes.home);
              // AppController.to.currentRoute.value = Routes.home;
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
                      ElevatedButton.icon(
                        icon: Image.asset(
                          'assets/google_logo.png',
                          width: 24,
                        ),
                        onPressed: () async {
                          try {
                            AuthResponse? auth = await AuthenticationNotifier
                                .instance
                                .googleSignIn();

                            if (auth?.user != null) {
                              Hive.box<UserMd>('user_box')
                                  .values
                                  .toList()
                                  .first;
                              //update controller

                              if (!context.mounted) return;
                              context.go(Routes.home);
                            } else {
                              // showSnackBar(context, 'Failed to sign in');
                              showToast('Failed to sign in', isSuccess: false);
                            }
                          } catch (e) {
                            // showSnackBar(context, 'Error: $e');
                            print('Error: $e');
                            showToast('Error: $e', isSuccess: false);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(326, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side:
                                const BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                        label: const Text('Log in with Gmail'),
                      ),
                    ],
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
