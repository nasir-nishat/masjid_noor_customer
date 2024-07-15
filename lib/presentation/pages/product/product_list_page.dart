import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';
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
                    bool isSelected = controller.selectedCategory.value ==
                        controller.categories[index];
                    return ChoiceChip(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      backgroundColor:
                          isSelected ? Colors.blue : Colors.transparent,
                      selectedColor: Colors.blue,
                      side: isSelected
                          ? BorderSide.none
                          : const BorderSide(color: Colors.grey),
                      showCheckmark: false,
                      label: Text(
                        controller.categories[index].name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      selected: isSelected,
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
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.w,
                            mainAxisSpacing: 10.h,
                            childAspectRatio: 0.8,
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
