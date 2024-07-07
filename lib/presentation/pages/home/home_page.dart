import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';

class HomePage extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('E-commerce')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Section
            Container(
              width: double.infinity,
              height: 200.h,
              color: Colors.blue,
              child: Center(
                  child: Text('Banner',
                      style: TextStyle(color: Colors.white, fontSize: 24.sp))),
            ),
            SizedBox(height: 20.h),

            // Top Products Section
            _buildProductSection('Top Products', productController.topProducts),

            // Popular Products Section
            _buildProductSection(
                'Popular Products', productController.popularProducts),
          ],
        ),
      ),
    );
  }

  Widget _buildProductSection(String title, List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
              TextButton(
                // onPressed: () => Get.to(() => AllProductsPage(title: title)),
                onPressed: () {},
                child: Text('See All', style: TextStyle(fontSize: 14.sp)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200.h, // Adjust height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _buildProductCard(products[index]);
            },
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      width: 150.w,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          Image.network(product.imageUrl, height: 100.h, fit: BoxFit.cover),
          Text(product.name, style: TextStyle(fontSize: 14.sp)),
        ],
      ),
    );
  }
}
