import 'package:go_router/go_router.dart';
import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';
import 'package:masjid_noor_customer/presentation/widgets/cart_icon_count.dart';

class HomePage extends GetView<ProductController> {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              _buildProductSection(
                  'New Products', controller.newProducts, context),
              _buildProductSection(
                  'Popular Products', controller.popularProducts, context),
            ],
          ),
        ));
  }

  Widget _buildProductSection(
      String title, List<ProductMd> products, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelMedium),
              TextButton(
                  onPressed: () {
                    controller.getCategories();
                    AppController.to.navIndex.value = 1;
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
        SizedBox(height: 10.h),
        SizedBox(
          height: 200.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductItem(
                product: products[index],
                parentRoute: Routes.home,
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
