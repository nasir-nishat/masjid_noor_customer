import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';
import 'package:masjid_noor_customer/presentation/widgets/cart_icon_count.dart';

import '../../../navigation/router.dart';
import '../../widgets/product_item.dart';

class ProductListPage extends GetView<ProductController> {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return RefreshIndicator(
                  onRefresh: () => controller.fetchProductsByCategory(),
                  child: controller.products.isEmpty
                      ? const Center(child: Text('No products found'))
                      : GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns in the grid
                            crossAxisSpacing:
                                10.w, // Horizontal space between grid items
                            mainAxisSpacing:
                                10.h, // Vertical space between grid items
                            childAspectRatio:
                                0.8, // Aspect ratio for the grid items
                          ),
                          itemCount: controller.products.length + 1,
                          itemBuilder: (context, index) {
                            if (index == controller.products.length) {
                              if (controller.isFetching.value) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return const SizedBox.shrink();
                              }
                            }
                            return ProductItem(
                              product: controller.products[index],
                              parentRoute: Routes.products,
                            );
                          },
                          controller: ScrollController()
                            ..addListener(() {
                              if (controller.isLoadingMoreEnabled &&
                                  ScrollController().position.pixels ==
                                      ScrollController()
                                          .position
                                          .maxScrollExtent) {
                                controller.loadMoreProducts();
                              }
                            }),
                        ),
                  // : ListView.builder(
                  //     itemCount: controller.products.length + 1,
                  //     itemBuilder: (context, index) {
                  //       if (index == controller.products.length) {
                  //         if (controller.isFetching.value) {
                  //           return const Center(
                  //               child: CircularProgressIndicator());
                  //         } else {
                  //           return const SizedBox.shrink();
                  //         }
                  //       }
                  //       return ProductItem(
                  //         product: controller.products[index],
                  //         parentRoute: Routes.products,
                  //       );
                  //     },
                  //     controller: ScrollController()
                  //       ..addListener(() {
                  //         if (controller.isLoadingMoreEnabled &&
                  //             ScrollController().position.pixels ==
                  //                 ScrollController()
                  //                     .position
                  //                     .maxScrollExtent) {
                  //           controller.loadMoreProducts();
                  //         }
                  //       }),
                  //   ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
