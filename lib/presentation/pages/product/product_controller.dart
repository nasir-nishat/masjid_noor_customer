import 'dart:async';

import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:masjid_noor_customer/presentation/pages/prayer/prayer_time_controller.dart';

class ProductController extends GetxController {
  static ProductController get to => Get.find();

  var newProducts = <ProductMd>[].obs;
  var popularProducts = <ProductMd>[].obs;
  var products = <ProductMd>[].obs;
  var selectedProduct = ProductMd(name: "", sellPrice: 0).obs;

  var categories = <CategoryMd>[].obs;
  var selectedCategory = CategoryMd(name: "").obs;

  var isLoading = true.obs;
  var isSearchLoading = false.obs;

  int pageSize = 10;
  RxInt currentPage = 1.obs;
  Rx<Filter> selectedFilter = Filter(type: '', value: '').obs;

  bool get isLoadingMoreEnabled =>
      products.length >= pageSize && !isLoading.value;

  var searchedProducts = <ProductMd>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNewProducts();
    fetchPopularProducts();
    getCategories();
  }

  void getCategories() async {
    try {
      var fetchedCategories = await ApiService().getCategories();
      categories.value = fetchedCategories;
      if (fetchedCategories.isNotEmpty) {
        selectedCategory.value = fetchedCategories.first;
        fetchProductsByCategory();
      }
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
    isLoading.value = true;
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

  Future<void> fetchProductsByCategory() async {
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
      isLoading.value = false;
    }
  }

  Future<void> searchProducts(String query) async {
    isSearchLoading.value = true;
    currentPage.value = 1;
    searchedProducts.clear();

    try {
      List<ProductMd> srchPrds =
          await ApiService().searchProducts(query, pageSize, currentPage.value);

      searchedProducts.value = srchPrds;
    } catch (e) {
      print("Error searching products: $e");
    } finally {
      isSearchLoading.value = false;
    }
  }

  Future<void> loadMoreSearchProducts(String query) async {
    isSearchLoading.value = true;
    currentPage.value++;

    try {
      List<ProductMd> fetchedProducts = await ApiService()
          .searchProducts(
        query,
        pageSize,
        currentPage.value,
      )
          .timeout(const Duration(seconds: 5), onTimeout: () {
        throw TimeoutException("Search operation timed out after 5 seconds");
      });

      searchedProducts.addAll(fetchedProducts);
    } catch (e) {
      print("Error loading more search products: $e");
    } finally {
      isSearchLoading.value = false;
    }
  }

  Future<void> loadMoreProducts() async {
    if (!isLoadingMoreEnabled) return;

    isLoading.value = true;
    currentPage.value++;

    int offset = (currentPage.value - 1) * pageSize;

    try {
      List<ProductMd> fetchedProducts = await ApiService().getProducts(
        from: offset,
        to: (offset + pageSize) - 1,
        filter: Filter(
          type: 'category_id',
          value: selectedCategory.value.id.toString(),
        ),
      );

      products.addAll(fetchedProducts);
    } catch (e) {
      print("Error loading more products: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
