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
        SizedBox(height: 10.h),
        Expanded(
          child: Obx(() => ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 2.h),
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
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4.r),
                              bottomRight: Radius.circular(4.r),
                            ),
                          ),
                          title: Text(
                            category.name,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight:
                                  controller.selectedCategory.value == category
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                          onTap: () {
                            controller.selectedCategory.value = category;
                            controller.fetchProductsByCategory();
                          },
                          trailing: Icon(
                            Icons.chevron_right,
                            color: controller.selectedCategory.value == category
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                      ));
                },
              )),
        ),
        Padding(
          padding: EdgeInsets.all(8.w),
          child: ElevatedButton.icon(
            onPressed: () {
              _navigateToHome(context);
            },
            icon: Icon(Icons.home, size: 20.sp),
            label: Text('Home', style: TextStyle(fontSize: 14.sp)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: Size(double.infinity, 34.h), // Adjust button height
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
