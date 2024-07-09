import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:masjid_noor_customer/navigation/router.dart';
import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';
import 'package:masjid_noor_customer/presentation/widgets/cart_item.dart';
import 'package:masjid_noor_customer/mgr/models/cart_md.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.cartItems.isEmpty) {
        return const Center(
          child: Text('Your cart is empty'),
        );
      }

      return ListView.separated(
        itemCount: controller.cartItems.length,
        itemBuilder: (context, index) {
          final CartMd cartProd = controller.cartItems[index];
          return CartItem(
            cartProd: cartProd,
            onDecrease: () {
              controller.decreaseQuantity(cartProd);
            },
            onIncrease: () {
              int stockQty = cartProd.product.stockQty ?? 0;
              if (stockQty > 0 && cartProd.quantity >= stockQty) {
                showSnackBar(context, 'Stock is not enough',
                    duration: const Duration(seconds: 1));

                return;
              }
              controller.increaseQuantity(cartProd);
            },
            onRemove: () {
              controller.removeFromCart(cartProd);
            },
          ); // Call the CartItem widget
        },
        separatorBuilder: (context, index) =>
            Divider(color: Colors.grey[300], thickness: 1.h),
      );
    });
  }
}
