import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';
import 'package:masjid_noor_customer/presentation/widgets/cart_item.dart';

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
          final product = controller.cartItems[index];
          return CartItem(
            product: product,
            onDecrease: () {
              controller.decreaseQuantity(product);
            },
            onIncrease: () {
              controller.increaseQuantity(product);
            },
            onRemove: () {
              controller.removeFromCart(product);
            },
          ); // Call the CartItem widget
        },
        separatorBuilder: (context, index) =>
            Divider(color: Colors.grey[300], thickness: 1.h),
      );
    });
  }
}

// Create the CartItem Widget
