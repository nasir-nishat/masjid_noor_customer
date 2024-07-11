import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_noor_customer/mgr/dependency/supabase_dep.dart';
import 'package:masjid_noor_customer/mgr/models/cart_md.dart';
import 'package:masjid_noor_customer/mgr/models/payment_md.dart';
import 'package:masjid_noor_customer/mgr/models/product_md.dart';
import 'package:masjid_noor_customer/mgr/services/api_service.dart';
import 'package:masjid_noor_customer/navigation/router.dart';

class CartController extends GetxController {
  static CartController get to {
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut<CartController>(() => CartController());
    }
    return Get.find<CartController>();
  }

  var cartItems = <CartMd>[].obs;
  PaymentMethod? paymentMethod;
  var contactNumber = '';
  var note = '';
  RxBool isLoading = false.obs;

  int get totalProdCount {
    return cartItems.fold(0, (total, cartItem) => total + cartItem.quantity);
  }

  double? get totalPrice =>
      double.tryParse(calculateTotalPrice().toStringAsFixed(2));

  void addToCart(ProductMd product) {
    CartMd? existingCartMd =
        cartItems.firstWhereOrNull((item) => item.product.id == product.id);

    if (existingCartMd != null) {
      increaseQuantity(existingCartMd);
    } else {
      cartItems.add(CartMd(product: product, quantity: 1));
    }
  }

  void clearCart() {
    cartItems.clear();
    cartItems.refresh();
  }

  void removeFromCart(CartMd cartItem) {
    cartItems.remove(cartItem);
  }

  void increaseQuantity(CartMd cartItem) {
    cartItem.quantity++;
    cartItems.refresh();
  }

  void decreaseQuantity(CartMd cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
      cartItems.refresh();
    }
  }

  double calculateTotalPrice() {
    return cartItems.fold(0, (total, cartItem) => total + cartItem.totalPrice);
  }

  void processOrder(BuildContext context) async {
    if (cartItems.isEmpty) {
      return;
    }
    isLoading.value = true;

    String userId = SupabaseDep.impl.supabase.auth.currentUser?.id ?? '';
    if (userId.isEmpty) {
      isLoading.value = false;
      showSnackBar(context, 'Please login to place order');
      return;
    }

    final orderDetails = await ApiService().placeOrder(
      cartItems: cartItems,
      contactNumber: contactNumber,
      userId: userId,
      note: '',
      paymentMethod: paymentMethod ?? PaymentMethod.cash,
    );

    if (orderDetails != null) {
      isLoading.value = false;
      clearCart();
      if (context.mounted) {
        context.pop();
      }
    }
    isLoading.value = false;
  }
}
