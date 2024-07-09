import 'package:get/get.dart';
import 'package:masjid_noor_customer/mgr/models/product_md.dart';

class CartController extends GetxController {
  static CartController get to {
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut<CartController>(() => CartController());
    }
    return Get.find<CartController>();
  }

  var cartItems = <ProductMd>[].obs;

  void addProduct(ProductMd product) {
    cartItems.add(product);
  }

  void removeProduct(ProductMd product) {
    cartItems.remove(product);
  }

  void increaseQuantity(ProductMd product) {
    int index = cartItems.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      cartItems[index] =
          cartItems[index].copyWith(cartQty: cartItems[index].cartQty! + 1);
    }
  }

  void decreaseQuantity(ProductMd product) {
    int index = cartItems.indexWhere((p) => p.id == product.id);
    if (index != -1 && cartItems[index].cartQty! > 1) {
      cartItems[index] =
          cartItems[index].copyWith(cartQty: cartItems[index].cartQty! - 1);
    }
  }
}
