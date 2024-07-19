import 'package:masjid_noor_customer/presentation/pages/all_export.dart';import 'package:shimmer/shimmer.dart';class CartItem extends StatelessWidget {  final CartMd cartProd;  final VoidCallback onIncrease;  final VoidCallback onDecrease;  final VoidCallback onRemove;  const CartItem({    super.key,    required this.cartProd,    required this.onIncrease,    required this.onDecrease,    required this.onRemove,  });  @override  Widget build(BuildContext context) {    return Row(      children: [        if (cartProd.product.images == null || cartProd.product.images!.isEmpty)          Container(            width: 100.w,            height: 100.h,            decoration: BoxDecoration(              color: Colors.grey[200],              borderRadius: BorderRadius.circular(10.r),            ),            child: const Center(              child: Text('No Image'),            ),          )        else          ClipRRect(              borderRadius: BorderRadius.circular(10),              child: CachedNetworkImage(                  imageUrl: cartProd.product.images?.first,                  width: 100.w,                  height: 100.h,                  fit: BoxFit.fill,                  errorWidget: (context, url, error) {                    return Container(                      width: 100.w,                      height: 100.h,                      decoration: BoxDecoration(                        color: Colors.grey[200],                      ),                      child: const Center(                        child: Text('No Image'),                      ),                    );                  },                  placeholder: (context, url) => Shimmer.fromColors(                      baseColor: Colors.grey[300]!,                      highlightColor: Colors.grey[100]!,                      child: Container(                          width: 100.w,                          height: 100.r,                          decoration: BoxDecoration(                            color: Colors.grey[200],                          ))))),        const SizedBox(width: 10),        Expanded(          child: SpacedColumn(            crossAxisAlignment: CrossAxisAlignment.start,            verticalSpace: 10.h,            children: [              Text(cartProd.product.name, style: context.textTheme.labelLarge),              Row(                children: [                  SizedBox(                    child: SpacedRow(                      mainAxisAlignment: MainAxisAlignment.spaceBetween,                      crossAxisAlignment: CrossAxisAlignment.center,                      horizontalSpace: 5.w,                      children: [                        GestureDetector(                            onTap: onIncrease,                            child: Container(                                decoration: BoxDecoration(                                  color: Colors.white,                                  border: Border.all(color: Colors.black38),                                  shape: BoxShape.circle,                                ),                                child: const HeroIcon(HeroIcons.plus))),                        SizedBox(                          width: 40.w,                          child: Center(                              child: Text((cartProd.quantity).toString(),                                  style:                                      context.textTheme.labelMedium?.copyWith(                                    color: Colors.black,                                    fontSize: 18,                                    fontWeight: FontWeight.bold,                                  ))),                        ),                        GestureDetector(                            onTap: onDecrease,                            child: Container(                                decoration: BoxDecoration(                                  color: Colors.white,                                  border: Border.all(color: Colors.black38),                                  shape: BoxShape.circle,                                ),                                child: const HeroIcon(HeroIcons.minus))),                      ],                    ),                  ),                ],              ),              Text(getPrice(), style: context.textTheme.labelMedium),            ],          ),        ),        IconButton(          icon: const HeroIcon(HeroIcons.trash),          onPressed: onRemove,        ),      ],    );  }  String getPrice() {    String prodP = cartProd.product.sellPrice.toStringAsFixed(2);    String prodQ = cartProd.quantity.toString();    double total = cartProd.product.sellPrice * cartProd.quantity;    String prodT = total.toStringAsFixed(2);    return "₩ $prodP x $prodQ = ₩ $prodT";  }}