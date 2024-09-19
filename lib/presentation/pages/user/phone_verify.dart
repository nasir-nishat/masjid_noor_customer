import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:masjid_noor_customer/presentation/pages/user/phone_verify_controller.dart';

class InputPhoneScreen extends StatelessWidget {
  final controller = Get.put(PhoneVerificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Phone Number')),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) => controller.phoneNumber.value = value,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20.h),
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => _showCaptchaDialog(context),
                  child: const Text('Verify CAPTCHA'),
                )),
            SizedBox(height: 20.h),
            Obx(() => ElevatedButton(
                  onPressed: () {
                    controller.sendOTP(context);
                  },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Send OTP'),
                )),
          ],
        ),
      ),
    );
  }

  void _showCaptchaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Verify CAPTCHA'),
          content: Container(
            width: 300,
            height: 100,
            child: Center(
              child: Container(
                width: 300,
                height: 100,
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Verify'),
                )),
          ],
        );
      },
    );
  }
}

class VerifyOTPScreen extends StatelessWidget {
  final controller = Get.find<PhoneVerificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) => controller.otp.value = value,
              decoration: const InputDecoration(labelText: 'Enter OTP'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.h),
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.verifyOTP(context),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Verify OTP'),
                )),
          ],
        ),
      ),
    );
  }
}
