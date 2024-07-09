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

  // TODO: FIX the count qty in product model
  void addToCart(ProductMd product) {
    ProductMd? existingProduct =
        cartItems.firstWhereOrNull((p) => p.id == product.id);

    if (existingProduct != null) {
      int index = cartItems.indexWhere((p) => p.id == product.id);
      cartItems[index] =
          cartItems[index].copyWith(cartQty: cartItems[index].cartQty! + 1);
    } else {
      existingProduct = product.copyWith(cartQty: 1);
    }
    cartItems.add(product);
  }

  void removeFromCart(ProductMd product) {
    cartItems.remove(product);
  }

  void increaseQuantity(ProductMd product) {
    int index = cartItems.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      print('index: $index');
      print(product.toJson());
      print("==============");
      print(cartItems);
      print("==============");
      int currentQty = cartItems[index].cartQty ?? 0;
      print("currentQty: $currentQty");
      cartItems[index] = cartItems[index].copyWith(cartQty: currentQty + 1);
    }
  }

  void decreaseQuantity(ProductMd product) {
    int index = cartItems.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      int currentQty = cartItems[index].cartQty ?? 0;
      if (currentQty > 1) {
        cartItems[index] = cartItems[index].copyWith(cartQty: currentQty - 1);
      }
    }
  }
}
