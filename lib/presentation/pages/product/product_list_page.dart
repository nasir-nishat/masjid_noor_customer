import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';

import '../../../navigation/router.dart';
import '../../widgets/product_item.dart';

class ProductListPage extends GetView<ProductController> {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    'Products',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Obx(() {
                        return ChoiceChip(
                          label: Text(controller.categories[index].name),
                          selected: controller.selectedCategory.value ==
                              controller.categories[index],
                          onSelected: (isSelected) {
                            if (isSelected) {
                              controller.selectedCategory.value =
                                  controller.categories[index];
                              controller.fetchProductsByCategory();
                            }
                          },
                        );
                      }),
                    );
                  },
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return NotificationListener<ScrollNotification>(
                      // onNotification: (scrollNotification) {
                      //   if (scrollNotification.metrics.pixels ==
                      //       scrollNotification.metrics.maxScrollExtent) {
                      //     if (!controller.isLoading.value) {
                      //       controller.loadMoreProducts();
                      //     }
                      //   }
                      //   return false;
                      // },
                      child: controller.products.isEmpty
                          ? const Center(child: Text('No products found'))
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.w,
                                mainAxisSpacing: 10.h,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: controller.products.length,
                              itemBuilder: (context, index) {
                                return ProductItem(
                                  product: controller.products[index],
                                  parentRoute: Routes.products,
                                );
                              },
                            ),
                    );
                  }
                }),
              ),
            ],
          )),
    );
  }
}
