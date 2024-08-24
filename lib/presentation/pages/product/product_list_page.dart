import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';
import '../../../navigation/router.dart';
import '../../widgets/product_item.dart';

class ProductListPage extends GetView<ProductController> {
  ProductListPage({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();
  final RxBool _showCategories = true.obs;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    _scrollController.addListener(() {
      if (controller.isLoadingMoreEnabled &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        controller.loadMoreProducts();
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        _showCategories.value = false;
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        _showCategories.value = true;
      }
    });

    return Scaffold(
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            controller.getCategories();
            controller.fetchProductsByCategory();
          },
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _showCategories.value ? 50.h : 0,
                child: SingleChildScrollView(
                  child: _buildCategories(),
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(child: _buildProductGrid()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 50.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: _buildCategoryChip(index),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(int index) {
    bool isSelected =
        controller.selectedCategory.value == controller.categories[index];
    return Obx(() => ChoiceChip(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          backgroundColor: isSelected ? Colors.blue : Colors.transparent,
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
              controller.selectedCategory.value = controller.categories[index];
              controller.fetchProductsByCategory();
            }
          },
        ));
  }

  Widget _buildProductGrid() {
    if (controller.isLoading.value && controller.products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else if (controller.products.isEmpty) {
      return const Center(child: Text('No products found'));
    } else {
      return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          childAspectRatio: 0.8,
        ),
        itemCount:
            controller.products.length + (controller.isLoading.value ? 2 : 0),
        itemBuilder: (context, index) {
          if (index >= controller.products.length) {
            return controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink();
          }
          return ProductItem(
            product: controller.products[index],
            parentRoute: Routes.products,
          );
        },
        controller: _scrollController,
      );
    }
  }
}
