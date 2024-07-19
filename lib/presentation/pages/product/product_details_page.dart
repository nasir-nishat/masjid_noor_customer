import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';

class ProductDetailsPage extends GetView<ProductController> {
  final String id;
  final String parentRoute;

  const ProductDetailsPage(
      {super.key, required this.id, required this.parentRoute});

  @override
  Widget build(BuildContext context) {
    ProductMd prod = controller.selectedProduct.value;
    bool isAvailable = prod.stockQty != null && prod.stockQty! > 0;
    return Scaffold(
      bottomSheet: Container(
        padding: EdgeInsets.all(10.w),
        color: Colors.white,
        child: isAvailable
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50.h),
                ),
                child: const Text("Add to Cart"),
                onPressed: () {
                  if (isAvailable) {
                    CartController.to.addToCart(prod);
                    context.push(Routes.cart);
                  } else {
                    // showSnackBar(context, "This product is out of stock");
                    showToast("This product is out of stock", isWarning: true);
                  }
                },
              )
            : Container(
                height: 50,
                color: Colors.grey[200],
                child: const Center(
                  child: Text(
                    "Out of Stock",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16..w),
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
              if (prod.images == null || prod.images!.isEmpty)
                Container(
                  width: 400.w,
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: const Center(
                    child: Text('No Image'),
                  ),
                )
              else
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  child: CachedNetworkImage(
                    imageUrl: prod.images?.firstOrNull,
                    errorWidget: (context, url, error) {
                      return Container(
                        width: 200.w,
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        child: const Center(
                          child: Text('No Image'),
                        ),
                      );
                    },
                    placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 200.h,
                          width: 200.w,
                          decoration: BoxDecoration(color: Colors.grey[200]),
                        )),
                  ),
                ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: SpacedColumn(
                  verticalSpace: 10,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Divider(
                    //     color: Colors.blueGrey,
                    //     height: 0.5.h,
                    //     thickness: 0.5.h),
                    Text(
                      prod.name,
                      style: context.textTheme.headlineLarge,
                    ),
                    Text(
                      "₩ ${prod.sellPrice.toString()}",
                      style: context.textTheme.headlineMedium
                          ?.copyWith(color: const Color(0xFFB00020)),
                    ),
                    if (prod.description != null &&
                        prod.description!.isNotEmpty) ...[
                      Divider(
                          color: Colors.blueGrey,
                          height: 0.5.h,
                          thickness: 0.5.h),
                      Text(
                        "Description",
                        style: context.textTheme.headlineMedium,
                      ),
                      SizedBox(
                        width: 700.w,
                        child: Text(
                          prod.description ?? "",
                          softWrap: true,
                          style: context.textTheme.bodyLarge,
                        ),
                      ),
                    ],
                    // Divider(
                    //     color: Colors.blueGrey,
                    //     height: 0.5.h,
                    //     thickness: 0.5.h),
                    SizedBox(
                        height: 80.h), // Extra space to avoid button overlap
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
