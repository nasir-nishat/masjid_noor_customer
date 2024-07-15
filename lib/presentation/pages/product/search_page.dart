import 'dart:async';import 'package:flutter/material.dart';import 'package:flutter/rendering.dart';import 'package:flutter_screenutil/flutter_screenutil.dart';import 'package:get/get.dart';import 'package:masjid_noor_customer/mgr/models/product_md.dart';import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';import 'package:masjid_noor_customer/presentation/widgets/product_item.dart';import '../../../navigation/router.dart';class SearchPage extends GetView<ProductController> {  const SearchPage({super.key});  @override  Widget build(BuildContext context) {    final TextEditingController searchController = TextEditingController();    final ScrollController scrollController = ScrollController();    Timer? fetchTimer;    scrollController.addListener(() {      if (scrollController.position.userScrollDirection ==          ScrollDirection.forward) {        fetchTimer?.cancel();        controller.isLoading.value = false;      }      if (scrollController.position.extentAfter < 500 &&          !controller.isLoading.value) {        // Start the fetch timer with a 2-second delay        fetchTimer?.cancel();        controller.isLoading.value = true;        fetchTimer = Timer(const Duration(seconds: 1), () {          controller.loadMoreSearchProducts(searchController.text);        });      }    });    return Obx(() => Column(          children: [            AppBar(              title: TextField(                controller: searchController,                autofocus: true,                decoration: InputDecoration(                  hintText: 'Search by name or description',                  border: InputBorder.none,                  suffixIcon: InkWell(                    onTap: () {                      controller.searchProducts(searchController.text);                    },                    child: const Icon(Icons.search),                  ),                ),                onSubmitted: (query) => controller.searchProducts(query),              ),            ),            SizedBox(height: 10.h),            Expanded(              child: Column(                children: [                  Expanded(                    child: Stack(                      children: [                        GridView.builder(                          controller: scrollController,                          padding: EdgeInsets.symmetric(horizontal: 12.w),                          gridDelegate:                              SliverGridDelegateWithFixedCrossAxisCount(                            crossAxisCount: 2,                            crossAxisSpacing: 10.w,                            mainAxisSpacing: 10.h,                            childAspectRatio: 0.8,                          ),                          itemCount: controller.searchedProducts.length,                          itemBuilder: (context, index) {                            if (controller.searchedProducts.isEmpty) {                              return const Center(                                  child: Text('No products found'));                            }                            ProductMd product =                                controller.searchedProducts[index];                            return ProductItem(                                product: product, parentRoute: Routes.search);                          },                        ),                        if (controller.isSearchLoading.value)                          const Positioned(                            bottom: 10,                            left: 0,                            right: 0,                            child: Center(                              child: CircularProgressIndicator(),                            ),                          ),                      ],                    ),                  ),                ],              ),            ),          ],        ));  }}