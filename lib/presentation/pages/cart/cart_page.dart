import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_noor_customer/mgr/dependency/supabase_dep.dart';
import 'package:masjid_noor_customer/mgr/models/payment_md.dart';
import 'package:masjid_noor_customer/navigation/router.dart';
import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';
import 'package:masjid_noor_customer/presentation/widgets/cart_item.dart';
import 'package:masjid_noor_customer/mgr/models/cart_md.dart';
import 'package:masjid_noor_customer/presentation/widgets/spaced_column.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
                  icon: const Icon(Icons.delete),
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
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
              ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
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
                    onPressed: () async {
                      if (SupabaseDep.impl.currentUser == null) {
                        context.push(Routes.login);
                        return;
                      }
                      final paymentMethod = await showPaymentDialog(context);
                      if (paymentMethod != null) {
                        if (paymentMethod == PaymentMethod.due) {
                          final dueInfo = await showDuePaymentDialog(context);
                          print(dueInfo);
                          // if (dueInfo != null) {
                          // controller.paymentMethod = paymentMethod;
                          // controller.userPhone = dueInfo['phone'];
                          // controller.kakaoId = dueInfo['kakaoId'];
                          // controller.facebookId = dueInfo['facebookId'];
                          // }
                        } else {
                          controller.paymentMethod = paymentMethod;
                        }
                      }
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

  Future<PaymentMethod?> showPaymentDialog(BuildContext context) {
    return showDialog<PaymentMethod>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Cash'),
                onTap: () {
                  Navigator.of(context).pop(PaymentMethod.cash);
                },
              ),
              ListTile(
                title: const Text('Bank Transfer'),
                onTap: () {
                  Navigator.of(context).pop(PaymentMethod.bankTransfer);
                },
              ),
              ListTile(
                title: const Text('Due'),
                onTap: () {
                  Navigator.of(context).pop(PaymentMethod.due);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Map?> showDuePaymentDialog(BuildContext context) async {
    final phoneController = TextEditingController();
    final nameController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    final maskFormatter = MaskTextInputFormatter(
      mask: '### #### ####',
      filter: {"#": RegExp(r'[0-9]')},
    );

    await showDialog<Map>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Due Payment Information'),
          content: Form(
            key: _formKey,
            child: SpacedColumn(
              mainAxisSize: MainAxisSize.min,
              verticalSpace: 10.h,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  inputFormatters: [maskFormatter],
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() == true) {
                  Navigator.of(context).pop({
                    'phone': phoneController.text,
                    'name': nameController.text,
                  });
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
    return null;
  }
}
