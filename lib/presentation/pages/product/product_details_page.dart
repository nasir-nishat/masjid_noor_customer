import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';

class ProductDetailsPage extends GetView<ProductController> {
  final String id;
  final String parentRoute;
  const ProductDetailsPage(
      {super.key, required this.id, required this.parentRoute});

  @override
  Widget build(BuildContext context) {
    ProductMd prod = controller.selectedProduct.value;
    return Scaffold(
      bottomSheet: Container(
        padding: EdgeInsets.all(10.w),
        color: Colors.white,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50.h),
          ),
          child: const Text("Add to Cart"),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    context.go(parentRoute);
                  },
                  icon: const Icon(Icons.close)),
            ),
            SizedBox(height: 20.h),
            Image.network(
              prod.images?.firstOrNull ??
                  'https://picsum.photos/id/230/200/200',
              height: 300.h,
              width: 500.w,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: SpacedColumn(
                verticalSpace: 10,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Text(
                    prod.name,
                    style: context.textTheme.headlineLarge,
                  ),
                  Text(
                    prod.sellPrice.toString(),
                    style: context.textTheme.headlineMedium
                        ?.copyWith(color: const Color(0xFFB00020)),
                  ),
                  if (prod.description != null &&
                      prod.description!.isNotEmpty) ...[
                    const Divider(),
                    Text(
                      "Description",
                      style: context.textTheme.headlineMedium,
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: 700.w,
                      child: Text(
                        prod.description ?? "",
                        softWrap: true,
                        style: context.textTheme.bodyLarge,
                      ),
                    ),
                  ],
                  const Divider(),
                  SizedBox(height: 80.h), // Extra space to avoid button overlap
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
