import 'package:go_router/go_router.dart';
import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';
import 'package:masjid_noor_customer/presentation/widgets/product_item.dart';

class ProductListPage extends GetView<ProductController> {
  final ProductController prodController = Get.find<ProductController>();

  ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: prodController.categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Chip(label: Text(prodController.categories[index])),
              );
            },
          ),
        ),
        Expanded(
          child: Obx(() {
            if (prodController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification.metrics.pixels ==
                      scrollNotification.metrics.maxScrollExtent) {
                    prodController.fetchProducts();
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
                  itemCount: prodController.products.length,
                  itemBuilder: (context, index) {
                    return ProductItem(
                      product: prodController.products[index],
                      productOnTap: () {
                        //TODO: SET URL AND Go to details of the item
                        context.go(Routes.productDetails,
                            extra: {'id': prodController.products[index].id});
                      },
                    );
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
