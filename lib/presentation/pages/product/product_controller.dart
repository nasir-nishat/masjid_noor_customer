import 'dart:async'; // Import Timer package
import 'package:get/get.dart';
import 'package:masjid_noor_customer/mgr/models/category_md.dart';
import 'package:masjid_noor_customer/mgr/services/api_service.dart';
import 'package:masjid_noor_customer/mgr/models/product_md.dart';

class ProductController extends GetxController {
  static ProductController get to {
    if (!Get.isRegistered<ProductController>()) {
      Get.lazyPut<ProductController>(() => ProductController());
    }
    return Get.find<ProductController>();
  }

  var newProducts = <ProductMd>[].obs;
  var popularProducts = <ProductMd>[].obs;
  var products = <ProductMd>[].obs;
  var selectedProduct = ProductMd(name: "", sellPrice: 0).obs;

  var categories = <CategoryMd>[].obs;
  var selectedCategory = CategoryMd(name: "").obs;

  var isLoading = true.obs;

  int pageSize = 10;
  RxInt currentPage = 1.obs;
  RxBool isFetching = false.obs;
  RxInt totalProduct = 0.obs;
  Rx<Filter> selectedFilter = Filter(type: '', value: '').obs;

  @override
  void onInit() {
    super.onInit();
    fetchNewProducts();
    fetchPopularProducts();
  }

  void getCategories() async {
    try {
      var fetchedCategories = await ApiService().getCategories();
      categories.value = fetchedCategories;
      selectedCategory.value = fetchedCategories.first;
      fetchProductsByCategory();
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  void fetchNewProducts() async {
    List<ProductMd> fetchedProducts = await ApiService().getProducts(
      from: 0,
      to: 10,
      filter: Filter(type: 'is_new', value: true),
    );
    newProducts.value = fetchedProducts..shuffle();
  }

  void fetchPopularProducts() async {
    var fetchedProducts = await ApiService().getProducts(
      from: 0,
      to: 10,
      filter: Filter(type: 'is_popular', value: true),
    );
    popularProducts.value = fetchedProducts;
  }

  void fetchProducts() async {
    int offset = (currentPage.value - 1) * pageSize;

    var fetchedProducts = await ApiService().getProducts(
      from: offset,
      to: (offset + pageSize) - 1,
      filter: selectedFilter.value,
    );

    if (currentPage.value == 1) {
      products.value = fetchedProducts;
    } else {
      products.addAll(fetchedProducts);
    }

    isLoading.value = false;
  }

  void fetchProductsByCategory() async {
    isLoading.value = true;
    currentPage.value = 1;
    products.clear();

    try {
      List<ProductMd> fetchedProducts = await ApiService().getProducts(
          from: 0,
          to: pageSize - 1,
          filter: Filter(
              type: 'category_id',
              value: selectedCategory.value.id.toString()));
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
