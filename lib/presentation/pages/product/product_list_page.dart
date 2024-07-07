import 'package:masjid_noor_customer/mgr/models/product_md.dart';
import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';

class ProductListPage extends GetView<ProductController> {
  final String title;
  final ProductController productController = Get.find<ProductController>();

  ProductListPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          // Categories Section
          Container(
            height: 50.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productController.categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Chip(label: Text(productController.categories[index])),
                );
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (productController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else {
                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification.metrics.pixels ==
                        scrollNotification.metrics.maxScrollExtent) {
                      productController.loadMoreProducts();
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
                    itemCount: productController.products.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(
                          productController.products[index]);
                    },
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductMd product) {
    return Card(
      child: Column(
        children: [
          Image.network(product.images?.first,
              height: 100.h, fit: BoxFit.cover),
          Text(product.name, style: TextStyle(fontSize: 14.sp)),
        ],
      ),
    );
  }
}
