import 'package:get/get.dart';
import 'package:masjid_noor_customer/mgr/services/api_service.dart';

import '../../../mgr/models/product_md.dart';

class ProductController extends GetxController {
  static ProductController get to {
    if (!Get.isRegistered<ProductController>()) {
      Get.lazyPut<ProductController>(() => ProductController());
    }
    return Get.find<ProductController>();
  }

  var topProducts = <ProductMd>[].obs;
  var popularProducts = <ProductMd>[].obs;
  var products = <ProductMd>[].obs;
  var categories = <String>['Category1', 'Category2', 'Category3'].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTopProducts();
    fetchPopularProducts();
    fetchProducts();
  }

  void fetchTopProducts() async {
    List<ProductMd> fetchedProducts = await ApiService.fetchTopProducts();
    topProducts.value = fetchedProducts;
  }

  void fetchPopularProducts() async {
    var fetchedProducts = await ApiService.fetchPopularProducts();
    popularProducts.value = fetchedProducts;
  }

  void fetchProducts() async {
    var fetchedProducts = await ApiService.fetchProducts();
    products.addAll(fetchedProducts);
    isLoading.value = false;
  }

  void loadMoreProducts() async {
    var fetchedProducts = await ApiService.fetchProducts();
    products.addAll(fetchedProducts);
  }
}
