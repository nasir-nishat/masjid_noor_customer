import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:masjid_noor_customer/kiosk/routes/app_pages.dart';
import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';

class CategoriesSection extends GetView<ProductController> {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Removed the top spacing to maximize vertical space
        Expanded(
          child: Obx(() => ListView.builder( // Changed to ListView.builder (no separator needed)
            padding: EdgeInsets.zero, // Remove default padding
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return Obx(() => Container(
                decoration: BoxDecoration(
                  color: controller.selectedCategory.value == category
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4.r),
                    bottomRight: Radius.circular(4.r),
                  ),
                ),
                child: InkWell( // Replaced ListTile with more compact InkWell
                  onTap: () {
                    controller.selectedCategory.value = category;
                    controller.fetchProductsByCategory();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h, // Reduced vertical padding
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            category.name,
                            style: TextStyle(
                              fontSize: 11.sp, // Slightly smaller font
                              fontWeight: controller.selectedCategory.value == category
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (controller.selectedCategory.value == category)
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12.sp,
                            color: Colors.blue,
                          )
                      ],
                    ),
                  ),
                ),
              ));
            },
          )),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h), // Reduced padding
          child: ElevatedButton.icon(
            onPressed: () {
              _navigateToHome(context);
            },
            icon: Icon(Icons.home, size: 18.sp), // Slightly smaller icon
            label: Text('Home', style: TextStyle(fontSize: 13.sp)), // Smaller text
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: Size(double.infinity, 30.h), // Reduced button height
              padding: EdgeInsets.symmetric(vertical: 0), // Minimum padding
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToHome(BuildContext context) {
    if (CartController.to.cartItems.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Warning'),
            content: const Text(
                'Your cart will be cleared. Do you want to proceed?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child:
                const Text('Cancel', style: TextStyle(color: Colors.black)),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  CartController.to.clearCart();
                  Get.back();
                },
                child: const Text('Go Home'),
              ),
            ],
          );
        },
      );
    } else {
      Get.toNamed(KioskRoutes.HOME);
    }
  }
}