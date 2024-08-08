import 'package:flutter/material.dart';import 'package:flutter_screenutil/flutter_screenutil.dart';import 'package:get/get.dart';import 'package:go_router/go_router.dart';import 'package:heroicons/heroicons.dart';import 'package:masjid_noor_customer/mgr/dependency/supabase_dep.dart';import 'package:masjid_noor_customer/mgr/models/payment_md.dart';import 'package:masjid_noor_customer/navigation/router.dart';import 'package:masjid_noor_customer/presentation/pages/cart/cart_controller.dart';import 'package:masjid_noor_customer/presentation/pages/user/profile_page.dart';import 'package:masjid_noor_customer/presentation/widgets/cart_item.dart';import 'package:masjid_noor_customer/mgr/models/cart_md.dart';import 'package:masjid_noor_customer/presentation/widgets/spaced_column.dart';import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';import 'barcode_scanner.dart';class CartPageV2 extends GetView<CartController> {  const CartPageV2({super.key});  @override  Widget build(BuildContext context) {    return Scaffold(      body: Obx(() => Column(            crossAxisAlignment: CrossAxisAlignment.center,            children: [              _buildAppBar(context),              SizedBox(height: 10.h),              _buildCartContent(),              SizedBox(height: 10.h),              _buildCheckoutSection(context),            ],          )),    );  }  Widget _buildAppBar(BuildContext context) {    return Padding(      padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),      child: Row(        children: [          Text(            'Cart',            style: TextStyle(              fontSize: 24.sp,              fontWeight: FontWeight.bold,            ),          ),          const Spacer(),          IconButton(            icon: const HeroIcon(HeroIcons.qrCode),            onPressed: () => _openBarcodeScanner(context),          ),          IconButton(            icon: const HeroIcon(HeroIcons.xMark),            onPressed: () => context.pop(),          ),        ],      ),    );  }  Widget _buildCartContent() {    if (controller.cartItems.isEmpty) {      return const Expanded(        child: Center(child: Text('Your cart is empty')),      );    }    return Expanded(      child: Padding(        padding: EdgeInsets.symmetric(horizontal: 8.w),        child: ListView.separated(          itemCount: controller.cartItems.length,          itemBuilder: (context, index) =>              _buildCartItem(controller.cartItems[index]),          separatorBuilder: (context, index) =>              Divider(color: Colors.grey[300], thickness: 1.h),        ),      ),    );  }  Widget _buildCartItem(CartMd cartProd) {    return CartItem(      cartProd: cartProd,      onDecrease: () => controller.decreaseQuantity(cartProd),      onIncrease: () => _handleIncreaseQuantity(cartProd),      onRemove: () => controller.removeFromCart(cartProd),    );  }  void _handleIncreaseQuantity(CartMd cartProd) {    int stockQty = cartProd.product.stockQty ?? 0;    if (stockQty > 0 && cartProd.quantity >= stockQty) {      showToast('Stock is not enough', isWarning: true);      return;    }    controller.increaseQuantity(cartProd);  }  Widget _buildCheckoutSection(BuildContext context) {    return Container(      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),      decoration: BoxDecoration(        color: Colors.white,        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),        boxShadow: [          BoxShadow(            color: Colors.grey.withOpacity(0.5),            spreadRadius: 5,            blurRadius: 7,            offset: const Offset(0, 3),          ),        ],      ),      child: Column(        children: [          _buildTotalPrice(),          SizedBox(height: 10.h),          _buildCheckoutButton(context),        ],      ),    );  }  Widget _buildTotalPrice() {    return Row(      mainAxisAlignment: MainAxisAlignment.spaceBetween,      children: [        Text(          'Total:',          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),        ),        Obx(() => Text(              '₩ ${controller.totalPrice}',              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),            )),      ],    );  }  Widget _buildCheckoutButton(BuildContext context) {    return ElevatedButton(      onPressed:          controller.cartItems.isEmpty ? null : () => _paymentFunc(context),      style: ElevatedButton.styleFrom(        padding: EdgeInsets.symmetric(vertical: 12.h),        minimumSize: Size(double.infinity, 40.h),      ),      child: Text(        'Proceed to Checkout',        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),      ),    );  }  void _openBarcodeScanner(BuildContext context) {    Navigator.of(context).push(      MaterialPageRoute(builder: (context) => const BarcodeScannerSimple()),    );  }  Future<void> _paymentFunc(BuildContext context) async {    if (SupabaseDep.impl.currentUser == null) {      context.push(Routes.login);      return;    }    final paymentMethod = await showPaymentDialog(context);    if (paymentMethod == null) return;    controller.paymentMethod = paymentMethod;    if (context.mounted) {      switch (paymentMethod) {        case PaymentMethod.due:          await _handleDuePayment(context);          break;        case PaymentMethod.bankTransfer:          await _handleBankTransfer(context);          break;        default:          await _processOrder(context);      }    }  }  Future<void> _handleDuePayment(BuildContext context) async {    final dueInfo = await showDuePaymentDialog(context);    if (dueInfo != null) {      controller.contactNumber = dueInfo['phone']!;      if (context.mounted) {        await _processOrder(context);      }    }  }  Future<void> _handleBankTransfer(BuildContext context) async {    bool orderDone = await _processOrder(context);    if (orderDone && context.mounted) {      showBankDetailsDialog(context);    }  }  Future<bool> _processOrder(BuildContext context) async {    if (!context.mounted) return false;    return await controller.processOrder(context);  }  Future<PaymentMethod?> showPaymentDialog(BuildContext context) {    return showDialog<PaymentMethod>(      context: context,      builder: (context) => AlertDialog(        title: const Text('Payment Method'),        content: Column(          mainAxisSize: MainAxisSize.min,          children: PaymentMethod.values              .map((method) => ListTile(                    title: Text(method.toString().split('.').last),                    onTap: () => Navigator.of(context).pop(method),                  ))              .toList(),        ),      ),    );  }  Future<Map<String, String>?> showDuePaymentDialog(      BuildContext context) async {    final phoneController = TextEditingController();    final formKey = GlobalKey<FormState>();    final maskFormatter = MaskTextInputFormatter(      mask: '### #### ####',      filter: {"#": RegExp(r'[0-9]')},    );    return showDialog<Map<String, String>>(      context: context,      builder: (context) => AlertDialog(        title: const Text('Due Payment Information'),        content: Form(          key: formKey,          child: SpacedColumn(            mainAxisSize: MainAxisSize.min,            verticalSpace: 10.h,            children: [              TextFormField(                controller: phoneController,                decoration: InputDecoration(                  labelText: 'Phone Number',                  prefix: Text('+82 ',                      style: TextStyle(fontSize: 16.sp, color: Colors.black)),                ),                inputFormatters: [maskFormatter],                keyboardType: TextInputType.phone,                validator: (value) => (value?.isEmpty ?? true)                    ? 'Phone number is required'                    : null,              ),            ],          ),        ),        actions: [          TextButton(            onPressed: () {              if (formKey.currentState?.validate() ?? false) {                Navigator.of(context)                    .pop({'phone': phoneController.text.removeAllWhitespace});              }            },            child: const Text('Submit'),          ),        ],      ),    );  }}