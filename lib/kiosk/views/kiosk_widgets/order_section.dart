import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:masjid_noor_customer/kiosk/routes/app_pages.dart';
import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';
import 'package:masjid_noor_customer/mgr/models/payment_md.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masjid_noor_customer/presentation/utills/extensions.dart';
import 'package:masjid_noor_customer/presentation/widgets/cart_item.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'number_pad.dart';

class OrderSection extends GetView<CartController> {
  OrderSection({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.w,
      padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Order',
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
                Obx(() => _buildTotalItemsBadge(
                    controller.cartItems.length, context)),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Expanded(
              child: Obx(() => (controller.cartItems.isEmpty)
                  ? _buildEmptyCartUI(context)
                  : _buildCartItem(context))),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: context.theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Column(
              children: [
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    Obx(() => SizedBox(
                          width: 150.w,
                          child: Text(
                            (controller.totalPrice ?? 0).toCurrency(),
                            maxLines: 2,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 8.h),
                ElevatedButton(
                  onPressed: () => _paymentFunc(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 30.h),
                  ),
                  child: Text(
                    'Confirm Order',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
    return ListView.separated(
      controller: _scrollController,
      separatorBuilder: (context, index) => const Divider(color: Colors.grey),
      itemCount: controller.cartItems.length,
      itemBuilder: (context, index) {
        final item = controller.cartItems[index];
        return CartItem(
          cartProd: item,
          onDecrease: () => controller.decreaseQuantity(item),
          onIncrease: () => controller.increaseQuantity(item),
          onRemove: () => controller.removeFromCart(item),
          isKiosk: true,
        );
      },
    );
  }

  Widget _buildEmptyCartUI(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HeroIcon(
            HeroIcons.shoppingCart,
            size: 80.sp,
            color: Colors.grey,
          ),
          SizedBox(height: 20.h),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Add items to your cart to see them here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalItemsBadge(int totalItems, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Text(
        '$totalItems items',
        style: TextStyle(
          fontSize: 8.sp,
          color: context.theme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _paymentFunc(BuildContext context) async {
    final paymentMethod = await showPaymentDialog(context);
    if (paymentMethod == null) return;

    controller.paymentMethod = paymentMethod;

    if (context.mounted) {
      switch (paymentMethod) {
        case PaymentMethod.due:
          await _handleDuePayment(context);
          break;
        case PaymentMethod.bankTransfer:
          await _handleBankTransfer(context);
          break;
        default:
          await _processOrder(context);
      }
    }
  }

  Future<void> _handleDuePayment(BuildContext context) async {
    final dueInfo = await showDuePaymentDialog(context);
    if (dueInfo != null) {
      controller.contactNumber = dueInfo['phone']!;
      if (context.mounted) {
        bool orderDone = await _processOrder(context);
        if (orderDone && context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Order Placed'),
              content: const Text(
                  'Your order has been placed successfully, Please pay the due amount as soon as possible'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _navigateToHome(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  Future<void> _handleBankTransfer(BuildContext context) async {
    bool orderDone = await _processOrder(context);
    if (orderDone && context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Order Placed'),
          content: const Text(
              'Please transfer the total amount to the bank account provided'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToHome(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<bool> _processOrder(BuildContext context) async {
    if (!context.mounted) return false;
    return await controller.processKioskOrder(controller.contactNumber);
  }

  Future<PaymentMethod?> showPaymentDialog(BuildContext context) {
    return showDialog<PaymentMethod>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Method'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: PaymentMethod.values
              .map((method) => ListTile(
                    title: getMethods(method),
                    onTap: () => Navigator.of(context).pop(method),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Text getMethods(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.bankTransfer:
        return const Text('Bank Transfer');
      case PaymentMethod.due:
        return const Text('Due Payment');
      case PaymentMethod.cash:
        return const Text('Cash');
    }
  }

  Future<Map<String, String>?> showDuePaymentDialog(
      BuildContext context) async {
    final phoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final maskFormatter = MaskTextInputFormatter(
      mask: '### #### ####',
      filter: {"#": RegExp(r'[0-9]')},
    );

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Due Payment Information'),
        content: SizedBox(
          width: 300.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKey,
                child: TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.w, horizontal: 16.w),
                    hintStyle: TextStyle(fontSize: 16.sp),
                    prefix: Text('+82 ',
                        style: TextStyle(fontSize: 16.sp, color: Colors.black)),
                  ),
                  inputFormatters: [maskFormatter],
                  keyboardType: TextInputType.phone,
                  validator: (value) => (value?.isEmpty ?? true)
                      ? 'Phone number is required'
                      : null,
                  readOnly: true,
                ),
              ),
              SizedBox(height: 16.h),
              NumberPad(
                onNumberTap: (number) {
                  if (phoneController.text.length < 11) {
                    phoneController.text += number;
                    maskFormatter.formatEditUpdate(
                      TextEditingValue(text: phoneController.text),
                      TextEditingValue(text: phoneController.text + number),
                    );
                  }
                },
                onBackspace: () {
                  if (phoneController.text.isNotEmpty) {
                    phoneController.text = phoneController.text
                        .substring(0, phoneController.text.length - 1);
                    maskFormatter.formatEditUpdate(
                      TextEditingValue(text: "${phoneController.text} "),
                      TextEditingValue(text: phoneController.text),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(context)
                    .pop({'phone': phoneController.text.replaceAll(' ', '')});
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    if (CartController.to.cartItems.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Warning'),
            content:
                const Text('Your cart is not empty. Do you want to proceed?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.black)),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  CartController.to.clearCart();
                  Get.back();
                },
                child: const Text('Go Home'),
              ),
            ],
          );
        },
      );
    } else {
      Get.toNamed(KioskRoutes.HOME);
    }
  }
}
