import 'package:masjid_noor_customer/presentation/pages/all_export.dart';import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';import 'package:masjid_noor_customer/presentation/widgets/single_image_viewer.dart';import 'package:shimmer/shimmer.dart';import 'cart_icon_count.dart';class ProductItem extends StatefulWidget {  final ProductMd product;  final String parentRoute;  const ProductItem({    super.key,    required this.product,    required this.parentRoute,  });  @override  _ProductItemState createState() => _ProductItemState();}class _ProductItemState extends State<ProductItem>    with TickerProviderStateMixin {  bool isTapped = false;  void addToCart(ProductMd product) {    CartController.to.addToCart(product);  }  @override  Widget build(BuildContext context) {    bool isStockAvailable =        widget.product.stockQty != null && widget.product.stockQty! > 0;    return SizedBox(      width: 170.w,      child: Align(        alignment: Alignment.center,        child: InkWell(          highlightColor: Colors.white,          splashColor: Colors.white,          hoverColor: Colors.white,          onHighlightChanged: (value) {            setState(() {              isTapped = value;            });          },          onTap: () {            ProductController.to.selectedProduct.value = widget.product;            context.go('${Routes.productDetails}/${widget.product.id}', extra: {              'id': widget.product.id.toString(),              'parentRoute': widget.parentRoute            });          },          child: AnimatedContainer(            duration: const Duration(milliseconds: 300),            curve: Curves.fastLinearToSlowEaseIn,            child: Column(              crossAxisAlignment: CrossAxisAlignment.start,              children: [                Stack(                  children: [                    if (widget.product.images != null &&                        widget.product.images!.isEmpty)                      Container(                        height: isTapped ? 130.h : 135.h,                        width: isTapped ? 170.w : 172.w,                        decoration: BoxDecoration(                          color: const Color(0xFFE0E0E0),                          borderRadius: BorderRadius.circular(10.r),                        ),                        child: Center(                          child: Text(                            'No Image',                            style: context.textTheme.labelMedium?.copyWith(                              color: const Color(0xFF2B3544),                            ),                          ),                        ),                      )                    else                      SingleImagesViewer(                        imageUrl: widget.product.images!.first,                        height: isTapped ? 130.h : 135.h,                        width: isTapped ? 170.w : 172.w,                      ),                    if (isStockAvailable)                      Positioned(                        bottom: 8,                        right: 10,                        child: InkWell(                          onTap: () {                            addToCart(widget.product);                          },                          child: Obx(() => CartIconCount(                                count: CartController.to.cartItems                                        .firstWhereOrNull((item) =>                                            item.product.id ==                                            widget.product.id)                                        ?.quantity ??                                    0,                              )),                        ),                      )                    else                      Positioned(                        bottom: 8,                        right: 10,                        child: Container(                          padding: EdgeInsets.symmetric(                              horizontal: 5.w, vertical: 2.h),                          decoration: BoxDecoration(                            color: Colors.red,                            borderRadius: BorderRadius.circular(5.r),                          ),                          child: Text(                            'Out of Stock',                            style: context.textTheme.labelMedium?.copyWith(                              color: Colors.white,                            ),                          ),                        ),                      ),                  ],                ),                Padding(                  padding: EdgeInsets.only(left: 5.w, top: 5.h),                  child: SpacedColumn(                    crossAxisAlignment: CrossAxisAlignment.start,                    children: [                      SizedBox(                        width: 248.w,                        child: Text(                          widget.product.name,                          maxLines: 2,                          overflow: TextOverflow.ellipsis,                          style: context.textTheme.labelMedium?.copyWith(                            color: const Color(0xFF2B3544),                          ),                        ),                      ),                      Text(                        "₩ ${widget.product.sellPrice.toString()}",                        style: context.textTheme.labelMedium?.copyWith(                          color: const Color(0xFF701515),                        ),                      ),                    ],                  ),                ),              ],            ),          ),        ),      ),    );  }}