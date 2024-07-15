import 'package:masjid_noor_customer/presentation/pages/all_export.dart';

import '../../../mgr/models/order_md.dart';

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

  Future<bool> processOrder(BuildContext context) async {
    if (cartItems.isEmpty) {
      return false;
    }
    AppController.to.showGlobalLoading();

    String userId = SupabaseDep.impl.supabase.auth.currentUser?.id ?? '';
    if (userId.isEmpty) {
      AppController.to.hideGlobalLoading();
      showSnackBar(context, 'Please login to place order');
      return false;
    }

    final String? orderId = await ApiService().placeOrder(
      cartItems: cartItems,
      contactNumber: contactNumber,
      userId: userId,
      note: '',
      paymentMethod: paymentMethod ?? PaymentMethod.cash,
    );
    print("++++++++++++++++++");
    print(orderId);
    print("++++++++++++++++++");

    if (orderId != null && orderId.isNotEmpty) {
      clearCart();
      if (context.mounted) {
        context.pop();
      }
      AppController.to.hideGlobalLoading();
      return true;
    }
    AppController.to.hideGlobalLoading();
    return false;
  }
}
