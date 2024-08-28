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
  ItemsListSection({super.key});

  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (controller.isLoadingMoreEnabled &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        _debounce?.cancel();
        _debounce = Timer(const Duration(seconds: 1), () {
          controller.loadMoreProducts();
        });
      }
    });

    return Obx(
      () => controller.isLoading.value && controller.products.isEmpty
          ? _buildShimmerLoading()
          : controller.products.isEmpty
              ? _buildEmptyListUI()
              : _buildItemList(),
    );
  }

  Widget _buildItemList() {
    return Stack(
      children: [
        GridView.builder(
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          padding: const EdgeInsets.all(10),
          itemCount:
              controller.products.length + (controller.isLoading.value ? 3 : 0),
          itemBuilder: (context, index) {
            if (index >= controller.products.length) {
              return _buildShimmerItem();
            }
            final product = controller.products[index];
            return _buildProductCard(product);
          },
        ),
        if (controller.isLoading.value)
          const Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Widget _buildProductCard(ProductMd product) {
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
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.sellPrice.toCurrency(),
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      CartController.to.addToCart(product);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 26.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child:
                        Text('Add to Order', style: TextStyle(fontSize: 12.sp)),
                  ),
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
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(10),
      itemCount: 9, // Show 9 shimmer items while loading
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
