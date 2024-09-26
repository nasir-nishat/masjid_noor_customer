// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:masjid_noor_customer/presentation/pages/user/phone_verify_controller.dart';
// import 'package:masjid_noor_customer/presentation/widgets/spaced_column.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// class InputPhoneScreen extends StatelessWidget {
//   final controller = Get.put(PhoneVerificationController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Enter Phone Number')),
//       body: Padding(
//         padding: EdgeInsets.all(16.w),
//         child: SpacedColumn(
//           verticalSpace: 20.h,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Verify your phone number", style: TextStyle(fontSize: 20.sp)),
//             SizedBox(height: 10.h),
//             const Text('Enter your phone number to receive OTP'),
//             SizedBox(height: 10.h),
//             TextField(
//               onChanged: (value) => controller.phoneNumber.value = value,
//               decoration: InputDecoration(
//                   labelText: 'Phone Number',
//                   prefixText: '+82 010 ',
//                   prefixStyle: TextStyle(color: Colors.black, fontSize: 16.sp)),
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 LengthLimitingTextInputFormatter(8),
//                 MaskTextInputFormatter(
//                     mask: '####-####', filter: {"#": RegExp(r'[0-9]')})
//               ],
//               keyboardType: TextInputType.phone,
//             ),
//             Obx(() => ElevatedButton(
//                   onPressed: () {
//                     controller.sendOTP(context);
//                   },
//                   child: controller.isLoading.value
//                       ? const CircularProgressIndicator()
//                       : const Text('Send OTP'),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showCaptchaDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Verify CAPTCHA'),
//           content: Container(
//             width: 300,
//             height: 100,
//             child: Center(
//               child: Container(
//                 width: 300,
//                 height: 100,
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             Obx(() => ElevatedButton(
//                   onPressed: controller.isLoading.value
//                       ? null
//                       : () {
//                           Navigator.of(context).pop();
//                         },
//                   child: controller.isLoading.value
//                       ? const CircularProgressIndicator()
//                       : const Text('Verify'),
//                 )),
//           ],
//         );
//       },
//     );
//   }
// }

// class VerifyOTPScreen extends StatelessWidget {
//   final controller = Get.find<PhoneVerificationController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Verify OTP')),
//       body: Padding(
//         padding: EdgeInsets.all(16.w),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               onChanged: (value) => controller.otp.value = value,
//               decoration: const InputDecoration(
//                 labelText: 'Enter OTP',
//               ),
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 LengthLimitingTextInputFormatter(6),
//               ],
//               textAlign: TextAlign.center,
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 20.h),
//             Obx(() => ElevatedButton(
//                   onPressed: controller.isLoading.value
//                       ? null
//                       : () => controller.verifyOTP(context),
//                   child: controller.isLoading.value
//                       ? const CircularProgressIndicator()
//                       : const Text('Verify OTP'),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }
