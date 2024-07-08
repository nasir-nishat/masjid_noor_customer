import 'package:go_router/go_router.dart';
import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';

class ProductListPage extends GetView<ProductController> {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Chip(label: Text(controller.categories[index])),
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
                onNotification: (scrollNotification) {
                  if (scrollNotification.metrics.pixels ==
                      scrollNotification.metrics.maxScrollExtent) {
                    controller.fetchProducts();
                  }
                  return false;
                },
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    return ProductItem(
                        product: controller.products[index],
                        parentRoute: Routes.products);
                  },
                ),
              );
            }
          }),
        ),
      ],
    );
  }
}
