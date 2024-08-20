import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:masjid_noor_customer/presentation/pages/prayer/prayer_time_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/prayer/prayer_time_page.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';

class HomePage extends GetView<ProductController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => RefreshIndicator(
          onRefresh: () async {
            await PrayerTimesController.to.getCurrentLocation(context);
            await PrayerTimesController.to.getBankDetails();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const PrayerTimesBanner(),
                SizedBox(height: 10.h),
                _buildProductSection(
                    'New Products', controller.newProducts, context),
                _buildProductSection(
                    'Popular Products', controller.popularProducts, context),
              ],
            ),
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
                  style: context.textTheme.labelMedium!.copyWith(
                      color: const Color(0xFF454F5A),
                      fontWeight: FontWeight.bold)),
              TextButton(
                  onPressed: () {
                    controller.getCategories();
                    context.go(Routes.products);
                  },
                  child: Text(
                    'See All',
                    style: context.textTheme.labelSmall
                        ?.copyWith(color: context.theme.primaryColor),
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
                parentRoute: Routes.home,
              );
            },
            separatorBuilder: (context, index) => SizedBox(width: 10.w),
          ),
        ),
      ],
    );
  }
}
