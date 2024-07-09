import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';
import 'package:masjid_noor_customer/mgr/models/product_md.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (CartController.to.cartItems.isEmpty) {
        return const Center(
          child: Text('Your cart is empty'),
        );
      }

      return ListView.builder(
        itemCount: CartController.to.cartItems.length,
        itemBuilder: (context, index) {
          ProductMd product = CartController.to.cartItems[index];

          return ListTile(
            title: Text(product.name),
            subtitle: Text('Price: ${product.sellPrice}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    CartController.to.decreaseQuantity(product);
                  },
                ),
                Obx(() => Text('${product.cartQty}')),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    CartController.to.increaseQuantity(product);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    CartController.to.removeProduct(product);
                  },
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
