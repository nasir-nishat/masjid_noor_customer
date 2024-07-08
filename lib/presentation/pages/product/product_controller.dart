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
  var selectedProduct = ProductMd(name: "", sellPrice: 0).obs;

  var categories = <String>['Category1', 'Category2', 'Category3'].obs;
  var selectedCategory = 'Category1'.obs;

  var isLoading = true.obs;

  int pageSize = 10;
  RxInt currentPage = 1.obs;
  RxBool isFetching = false.obs;
  RxInt totalProduct = 0.obs;
  Rx<Filter> selectedFilter = Filter(type: '', value: '').obs;

  @override
  void onInit() {
    super.onInit();
    fetchTopProducts();
    fetchPopularProducts();
    fetchProducts();
  }

  void fetchTopProducts() async {
    // List<ProductMd> fetchedProducts = await ApiService().fetchTopProducts();
    // topProducts.value = fetchedProducts;
    //add dummy data
    topProducts.value = [
      ProductMd(
        id: 1,
        name: 'Product 1',
        sellPrice: 2000,
      ),
      ProductMd(
        id: 2,
        name: 'Product 2',
        sellPrice: 2000,
      ),
      ProductMd(
        id: 3,
        name: 'Product 3',
        sellPrice: 2000,
      ),
    ];
  }

  void fetchPopularProducts() async {
    // var fetchedProducts = await ApiService().fetchPopularProducts();
    // popularProducts.value = fetchedProducts;

    topProducts.value = [
      ProductMd(
        id: 1,
        name: 'Product 1',
        sellPrice: 2000,
      ),
      ProductMd(
        id: 2,
        name: 'Product 2',
        sellPrice: 2000,
      ),
      ProductMd(
        id: 3,
        name: 'Product 3',
        sellPrice: 2000,
      ),
    ];
  }

  void fetchProducts() async {
    // int offset = (currentPage.value - 1) * pageSize;
    //
    // var fetchedProducts = await ApiService().getProducts(
    //   from: offset,
    //   to: (offset + pageSize) - 1,
    //   filter: selectedFilter.value,
    // );

    products.value = [
      ProductMd(
        id: 1,
        name: 'Product 1',
        sellPrice: 2000,
      ),
      ProductMd(
        id: 2,
        name: 'Product 2',
        sellPrice: 2000,
      ),
      ProductMd(
        id: 3,
        name: 'Product 3',
        sellPrice: 2000,
      ),
    ];

    isLoading.value = false;
  }
}
