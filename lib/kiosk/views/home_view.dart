import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';
import 'package:masjid_noor_customer/presentation/widgets/spaced_column.dart';
import '../routes/app_pages.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop, result) {
        _showExitPinDialog(context);
      },
      child: BarcodeKeyboardListener(
        onBarcodeScanned: (String barcode) {
          ProductController.to.addProductToCartByBarcode(barcode);
          Get.toNamed(KioskRoutes.KIOSK);
        },
        child: Scaffold(
          body: Center(
            child: SpacedColumn(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              verticalSpace: 10.h,
              children: [
                SizedBox(height: 10.h),
                Text(
                  'السلام عليكم',
                  style:
                      TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Noor Mart',
                  style:
                      TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 10),
                      autoPlayAnimationDuration: const Duration(seconds: 1),
                      viewportFraction: 1.0,
                      height: 250.h,
                    ),
                    items: [
                      'https://i.pinimg.com/1200x/bd/cd/62/bdcd6274d43ef682ad8da8eddf3790a7.jpg',
                      'https://i.pinimg.com/1200x/d8/ea/ab/d8eaaba5923b5576fae39bf9783133d7.jpg',
                    ].map((imageUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 100.w),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 10.h),
                ElevatedButton(
                  onPressed: () {
                    CartController.to.clearCart();
                    Get.toNamed(KioskRoutes.KIOSK);
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
                    child: Text(
                      'Order Now',
                      style: TextStyle(fontSize: 24.sp),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showExitPinDialog(BuildContext context) async {
    String pin = '';
    const correctPin = '1234'; // Set your PIN here

    bool exitApp = false;

    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter PIN to Exit'),
          content: TextField(
            onChanged: (value) {
              pin = value;
            },
            obscureText: true, // Hide the PIN input
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Enter PIN"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                if (pin == correctPin) {
                  exitApp = true;
                  SystemNavigator.pop();
                } else {
                  BotToast.showText(text: 'Incorrect PIN');
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return exitApp;
  }
}
