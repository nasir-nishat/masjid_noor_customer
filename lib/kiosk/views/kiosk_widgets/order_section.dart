import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';
import 'package:masjid_noor_customer/mgr/models/payment_md.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masjid_noor_customer/presentation/widgets/cart_item.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class OrderSection extends GetView<CartController> {
  OrderSection({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.w,
      padding: EdgeInsets.all(8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Order',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              Obx(() => _buildTotalItemsBadge(controller.cartItems.length)),
            ],
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    Obx(() => SizedBox(
                          width: 120.w,
                          child: Text(
                            '₩${controller.totalPrice}',
                            maxLines: 2,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 8.h),
                ElevatedButton(
                  onPressed: () => _paymentFunc(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40.h),
                  ),
                  child: Text(
                    'Confirm Order',
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
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

  Widget _buildTotalItemsBadge(int totalItems) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        '$totalItems items',
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.white,
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
        await _processOrder(context);
      }
    }
  }

  Future<void> _handleBankTransfer(BuildContext context) async {
    bool orderDone = await _processOrder(context);
    if (orderDone && context.mounted) {
      // TODO: Implement showBankDetailsDialog
      // showBankDetailsDialog(context);
    }
  }

  Future<bool> _processOrder(BuildContext context) async {
    if (!context.mounted) return false;
    return await controller.processOrder(context);
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
                    title: Text(method.toString().split('.').last),
                    onTap: () => Navigator.of(context).pop(method),
                  ))
              .toList(),
        ),
      ),
    );
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
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefix: Text('+82 ',
                  style: TextStyle(fontSize: 16.sp, color: Colors.black)),
            ),
            inputFormatters: [maskFormatter],
            keyboardType: TextInputType.phone,
            validator: (value) =>
                (value?.isEmpty ?? true) ? 'Phone number is required' : null,
          ),
        ),
        actions: [
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
}
