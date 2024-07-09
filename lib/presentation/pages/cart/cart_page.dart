import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_noor_customer/navigation/router.dart';
import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';
import 'package:masjid_noor_customer/presentation/widgets/cart_item.dart';
import 'package:masjid_noor_customer/mgr/models/cart_md.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Text(
                  'Cart',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.clearCart();
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            if (controller.cartItems.isEmpty)
              const Center(
                child: Text('Your cart is empty'),
              )
            else
              Expanded(
                child: ListView.separated(
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
                ),
              ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Obx(() {
                        return Text(
                          '₩ ${controller.totalPrice}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    onPressed: () {
                      // Handle checkout action
                      // Example: Navigate to checkout page
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      minimumSize: Size(double.infinity, 40.h),
                    ),
                    child: Text(
                      'Proceed to Checkout',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
