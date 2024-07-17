import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:masjid_noor_customer/mgr/dependency/supabase_dep.dart';
import 'package:masjid_noor_customer/mgr/models/payment_md.dart';
import 'package:masjid_noor_customer/navigation/router.dart';
import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';
import 'package:masjid_noor_customer/presentation/pages/user/profile_page.dart';
import 'package:masjid_noor_customer/presentation/widgets/cart_item.dart';
import 'package:masjid_noor_customer/mgr/models/cart_md.dart';
import 'package:masjid_noor_customer/presentation/widgets/spaced_column.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'barcode_scanner.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
              child: Row(
                children: [
                  Text(
                    'Cart',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const BarcodeScannerSimple(),
                        ),
                      );
                    },
                    child: const HeroIcon(HeroIcons.qrCode),
                  ),
                  InkWell(
                    onTap: () {
                      context.pop();
                      // controller.clearCart();
                    },
                    child: const HeroIcon(HeroIcons.xMark),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            if (controller.cartItems.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('Your cart is empty'),
                ),
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
                            // showSnackBar(context, 'Stock is not enough',
                            //     duration: const Duration(seconds: 1));
                            showToast('Stock is not enough', isWarning: true);
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
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
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
                    onPressed: controller.cartItems.isEmpty
                        ? null
                        : () {
                            _paymentFunc(context);
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

  _paymentFunc(BuildContext context) async {
    if (SupabaseDep.impl.currentUser == null) {
      context.push(Routes.login);
      return;
    }
    final paymentMethod = await showPaymentDialog(context);
    if (paymentMethod != null) {
      controller.paymentMethod = paymentMethod;
      if (paymentMethod == PaymentMethod.due) {
        if (!context.mounted) return;
        Map<String, String>? dueInfo = await showDuePaymentDialog(context);
        if (dueInfo != null) {
          controller.contactNumber = dueInfo['phone']!;
          if (!context.mounted) return;
          controller.processOrder(context);
        } else {
          return;
        }
      } else if (paymentMethod == PaymentMethod.bankTransfer) {
        if (!context.mounted) return;
        bool orderDone = await controller.processOrder(context);
        if (!orderDone) return;
        if (!context.mounted) return;
        showBankDetailsDialog(context);
      } else {
        if (!context.mounted) return;
        controller.processOrder(context);
      }
    }
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

  Future<Map<String, String>?> showDuePaymentDialog(
      BuildContext context) async {
    final phoneController = TextEditingController();
    // final nameController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    final maskFormatter = MaskTextInputFormatter(
      mask: '### #### ####',
      filter: {"#": RegExp(r'[0-9]')},
    );

    final result = await showDialog<Map<String, String>>(
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
                // TextFormField(
                //   controller: nameController,
                //   decoration: const InputDecoration(labelText: 'Name'),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Name is required';
                //     }
                //     return null;
                //   },
                // ),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefix: Text('+82 ',
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black))),
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
                  Map<String, String> data = {
                    'phone': phoneController.text.removeAllWhitespace,
                    // 'name': nameController.text,
                  };
                  Navigator.of(context).pop(data);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );

    return result;
  }
}
