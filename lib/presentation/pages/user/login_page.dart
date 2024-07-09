// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_noor_customer/navigation/router.dart';
import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:masjid_noor_customer/presentation/pages/app_controller.dart';
import 'package:masjid_noor_customer/presentation/utills/validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final supabase = Supabase.instance.client;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  TextEditingController userEmailCtrl =
      TextEditingController(text: kDebugMode ? 'nishatnasir00@gmail.com' : '');
  TextEditingController userPassCtrl =
      TextEditingController(text: kDebugMode ? 'Test123' : '');
  bool isLoading = false;
  String errorMessage = '';

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
                          // 'Assalamu Alaikum, Ahlan wa Sahlan',
                          "السلام عليكم و رحمة الله و بركاته\n",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          controller: userEmailCtrl,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: Validator.emailValidator,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          controller: userPassCtrl,
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: Validator.passwordValidator,
                          onFieldSubmitted: (_) => login(),
                        ),
                        const SizedBox(height: 10.0),
                        if (errorMessage.isNotEmpty)
                          Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.red),
                          )
                        else
                          const SizedBox.shrink(),
                        TextButton(
                          onPressed: () {
                            context.push(Routes.forgotPassword);
                          },
                          child: Text('Forgot Password?',
                              style: context.textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).primaryColor)),
                        ),
                        const SizedBox(height: 20.0),
                        if (isLoading) const CircularProgressIndicator(),
                        ElevatedButton(
                          onPressed: login,
                          child: const Text('Login'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      context.push(Routes.signup);
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    if (loginFormKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final errorMessage = await AuthenticationNotifier.instance
          .login(userEmailCtrl.text.trim(), userPassCtrl.text.trim());

      setState(() {
        isLoading = false;
      });

      if (errorMessage.isError) {
        Routes.showErrorDialog(errorMessage.error!.message);
      } else {
        AppController.to.userEmail.value =
            supabase.auth.currentUser?.email ?? '';
        Routes.goToHomePage(context);
      }
    }
  }
}
