import 'dart:async'; // Import Timer package
import 'package:get/get.dart';
import 'package:masjid_noor_customer/mgr/services/api_service.dart';
import 'package:masjid_noor_customer/mgr/models/product_md.dart';

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
    // Add dummy data
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

    popularProducts.value = [
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

  void fetchProductsByCategory(String category) async {
    isLoading.value = true;
    currentPage.value = 1;
    products.clear();

    // Set a timer to turn off isLoading after 10 seconds if it hasn't already
    Timer(Duration(seconds: 10), () {
      if (isLoading.value) {
        isLoading.value = false;
      }
    });

    // Fetch products based on the selected category
    try {
      List<ProductMd> fetchedProducts = await ApiService()
          .fetchProductsByFilter(
              from: 0,
              to: pageSize - 1,
              filterType: "categories",
              filterValue: category);
      products.value = fetchedProducts;
    } catch (e) {
      print("Error fetching products by category: $e");
    } finally {
      if (isLoading.value) {
        isLoading.value = false;
      }
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      currentPage.value = 1;
      products.clear();
      fetchProducts();
      return;
    }

    isFetching.value = true;

    // Fetch products based on the search query
    List<ProductMd> searchedProducts =
        await ApiService().searchProducts(query, pageSize, currentPage.value);

    if (currentPage.value == 1) {
      products.value = searchedProducts;
    } else {
      products.addAll(searchedProducts);
    }

    isFetching.value = false;
  }

  Future<void> loadMoreProducts() async {
    if (isFetching.value) return;

    currentPage.value++;
    await searchProducts('');
  }
}
