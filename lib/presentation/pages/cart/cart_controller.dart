import 'package:get/get.dart';
import 'package:masjid_noor_customer/mgr/models/cart_md.dart';
import 'package:masjid_noor_customer/mgr/models/product_md.dart';

class CartController extends GetxController {
  static CartController get to {
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut<CartController>(() => CartController());
    }
    return Get.find<CartController>();
  }

  var cartItems = <CartMd>[].obs;

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
}
