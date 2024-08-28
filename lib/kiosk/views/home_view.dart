import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';
import '../routes/app_pages.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BarcodeKeyboardListener(
      onBarcodeScanned: (String barcode) {
        ProductController.to.addProductToCartByBarcode(barcode);
        Get.toNamed(KioskRoutes.KIOSK);
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to An-Noor Kiosk',
                style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40.h),
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
            ],
          ),
        ),
      ),
    );
  }
}
