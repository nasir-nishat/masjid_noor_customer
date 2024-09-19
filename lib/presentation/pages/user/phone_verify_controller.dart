import 'package:firebase_auth/firebase_auth.dart';
import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PhoneVerificationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  var phoneNumber = ''.obs;
  var verificationId = ''.obs;
  var otp = ''.obs;
  var isLoading = false.obs;

  String get phoneNumberFormatted => '+82010${phoneNumber.replaceAll('-', '')}';

  Future<void> sendOTP(BuildContext context) async {
    isLoading.value = true;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumberFormatted,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          await _updateSupabaseUser();
          if (context.mounted) {
            context.go(Routes.home);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed');
          print('===>>>Error: ${e.message}');
          showToast(e.message ?? 'Verification failed', isSuccess: false);
        },
        codeSent: (String verId, int? resendToken) {
          print('Code sent');
          print('Verification ID: $verId');
          print('Resend Token: $resendToken');
          verificationId.value = verId;
          context.push(Routes.verifyOtp);
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId.value = verId;
        },
      );
    } catch (e) {
      showToast('Failed to send OTP', isSuccess: false);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOTP(BuildContext context) async {
    isLoading.value = true;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp.value,
      );
      await _auth.signInWithCredential(credential);
      await _updateSupabaseUser();
      if (context.mounted) {
        context.go(Routes.home);
        showToast('Phone number verified successfully');
      }
    } catch (e) {
      showToast('Invalid OTP', isSuccess: false);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _updateSupabaseUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _supabase.from('users').update({
        'phone_number': phoneNumberFormatted,
        'is_verified_phone': true,
      }).eq('email', AuthenticationNotifier().usermd!.email);
    }
  }
}
