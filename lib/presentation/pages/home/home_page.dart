import 'package:go_router/go_router.dart';
import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';

class HomePage extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            child: Image.network(
              'https://picsum.photos/200/300',
              height: 180.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(height: 20.h),

          // Top Products Section
          _buildProductSection(
              'Top Products', productController.topProducts, context),

          // Popular Products Section
          _buildProductSection(
              'Popular Products', productController.popularProducts, context),
        ],
      ),
    );
  }

  Widget _buildProductSection(
      String title, List<ProductMd> products, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: context.textTheme.labelMedium),
              TextButton(
                  onPressed: () {
                    context.go(Routes.products);
                  },
                  child: Text(
                    'See All',
                    style: context.textTheme.labelSmall
                        ?.copyWith(color: Colors.blue),
                  )),
            ],
          ),
        ),
        SizedBox(
          height: 200.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductItem(
                product: products[index],
              );
            },
            separatorBuilder: (context, index) => SizedBox(width: 10.w),
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
