import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:masjid_noor_customer/mgr/models/jamah_md.dart';
import 'package:masjid_noor_customer/mgr/models/product_md.dart';
import 'package:masjid_noor_customer/presentation/utills/extensions.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';
import '../../../presentation/pages/cart/cart_controller.dart';

class ItemsListSection extends GetView<ProductController> {
  const ItemsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value && controller.products.isEmpty
          ? _buildShimmerLoading()
          : controller.products.isEmpty
              ? _buildEmptyListUI()
              : _buildItemList(context),
    );
  }

  Widget _buildItemList(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.58,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: const EdgeInsets.all(10),
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              final product = controller.products[index];
              return _buildProductCard(product, context);
            },
          ),
        ),
        _buildPaginationControls(context),
      ],
    );
  }

  Widget _buildPaginationControls(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(80.w, 20.h),
            ),
            onPressed: controller.currentPage.value > 1
                ? () {
                    controller.loadMoreProducts(showPrev: true);
                  }
                : null,
            child: const Text('Previous'),
          ),
          SizedBox(width: 20.w),
          Obx(() => Text('Page ${controller.currentPage.value}')),
          SizedBox(width: 20.w),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(80.w, 20.h),
            ),
            onPressed: controller.isLoadingMoreEnabled
                ? () {
                    controller.loadMoreProducts();
                  }
                : null,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductMd product, BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
                image: DecorationImage(
                  image: product.images?.isNotEmpty == true
                      ? NetworkImage(product.images!.first)
                      : const AssetImage('assets/no_image.png')
                          as ImageProvider,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      product.name,
                      style: TextStyle(
                          fontSize: 10.sp, fontWeight: FontWeight.bold),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    product.sellPrice.toCurrency(),
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      CartController.to.addToCart(product);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          context.theme.primaryColor.withOpacity(0.1),
                      minimumSize: Size(double.infinity, 26.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child:
                        Text('Add to Order', style: TextStyle(fontSize: 10.sp)),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.58,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(10),
      itemCount: controller.pageSize,
      itemBuilder: (_, __) => _buildShimmerItem(),
    );
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(8.r)),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 12.h,
                      color: Colors.white,
                    ),
                    Container(
                      width: 60.w,
                      height: 12.h,
                      color: Colors.white,
                    ),
                    Container(
                      width: double.infinity,
                      height: 26.h,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyListUI() {
    return Center(
      child: Text(
        'No items found',
        style: TextStyle(fontSize: 20.sp),
      ),
    );
  }
}
