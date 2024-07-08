import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';

class ProductDetailsPage extends GetView<ProductController> {
  final String id;
  const ProductDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    ProductMd prod = controller.selectedProduct.value;
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.network(
            prod.images?.firstOrNull ?? 'https://picsum.photos/id/230/200/200',
            height: 300.h,
            width: 500.w,
            fit: BoxFit.fill,
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.only(left: 20.w),
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
                  Text(prod.sellPrice.toString(),
                      style: context.textTheme.headlineMedium
                          ?.copyWith(color: const Color(0xFFB00020))),
                  // Text(
                  //   "${prod.weight} gram",
                  //   textStyle: ThemeTextSemibold.xl3
                  //       .copyWith(color: ThemeColors.emerald600),
                  // ),
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
                  const Divider(),
                  FilledButton(
                    child: const Text("Add to Cart"),
                    onPressed: () {},
                  ),
                  SizedBox(height: 20.h),
                ]),
          ),
        ],
      ),
    );
  }
}
