import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:masjid_noor_customer/mgr/models/order_md.dart';
import 'package:masjid_noor_customer/presentation/pages/all_export.dart';

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

  final String _cartKey = 'cart_items';

  @override
  void onInit() {
    super.onInit();
    _loadCartData();
  }

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
    _saveCartData();
  }

  void clearCart() {
    cartItems.clear();
    _saveCartData();
  }

  void removeFromCart(CartMd cartItem) {
    cartItems.remove(cartItem);
    _saveCartData();
  }

  void increaseQuantity(CartMd cartItem) {
    cartItem.quantity++;
    cartItems.refresh();
    _saveCartData();
  }

  void decreaseQuantity(CartMd cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
      cartItems.refresh();
      _saveCartData();
    }
  }

  double calculateTotalPrice() {
    return cartItems.fold(0, (total, cartItem) => total + cartItem.totalPrice);
  }

  Future<void> _saveCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItemsJson =
        cartItems.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(_cartKey, cartItemsJson);
  }

  Future<void> _loadCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItemsJson = prefs.getStringList(_cartKey);
    if (cartItemsJson != null) {
      cartItems.value = cartItemsJson
          .map((item) => CartMd.fromJson(jsonDecode(item)))
          .toList();
    }
  }

  Future<bool> processOrder(BuildContext context) async {
    if (cartItems.isEmpty) {
      return false;
    }
    AppController.to.showGlobalLoading();

    String userId = SupabaseDep.impl.supabase.auth.currentUser?.id ?? '';
    if (userId.isEmpty) {
      AppController.to.hideGlobalLoading();
      showToast('Please login to place order', isWarning: true);
      return false;
    }

    final String? orderId = await ApiService().placeOrder(
      cartItems: cartItems,
      contactNumber: contactNumber,
      userId: userId,
      note: '',
      paymentMethod: paymentMethod ?? PaymentMethod.cash,
    );

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

  Future<bool> processKioskOrder(String? phoneNum) async {
    if (cartItems.isEmpty) {
      return false;
    }
    AppController.to.showGlobalLoading();

    String userId = Constants.noorMartId;

    final String? orderId = await ApiService().placeOrder(
      cartItems: cartItems,
      contactNumber: phoneNum ?? '',
      userId: userId,
      note: '',
      paymentMethod: paymentMethod ?? PaymentMethod.cash,
      status: OrderStatus.kiosk,
    );

    if (orderId != null && orderId.isNotEmpty) {
      clearCart();
      AppController.to.hideGlobalLoading();
      return true;
    }
    AppController.to.hideGlobalLoading();
    return false;
  }
}
