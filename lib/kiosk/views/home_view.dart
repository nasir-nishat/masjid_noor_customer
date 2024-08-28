import 'package:flutter/material.dart';
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
    return BarcodeKeyboardListener(
      onBarcodeScanned: (String barcode) {
        ProductController.to.addProductToCartByBarcode(barcode);
        Get.toNamed(KioskRoutes.KIOSK);
      },
      child: Scaffold(
        body: Center(
          child: SpacedColumn(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalSpace: 20.h,
            children: [
              SizedBox(height: 10.h),
              Text(
                'Welcome to An-Noor Kiosk',
                style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold),
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
                    'https://picsum.photos/800/400?random=1',
                    'https://picsum.photos/800/400?random=2',
                    'https://picsum.photos/800/400?random=3',
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
    );
  }
}
