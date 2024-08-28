import 'dart:async';

import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:masjid_noor_customer/presentation/pages/prayer/prayer_time_controller.dart';

import '../cart/cart_controller.dart';

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
  var selectedProduct = const ProductMd(name: "", sellPrice: 0).obs;

  var categories = <CategoryMd>[].obs;
  var selectedCategory = const CategoryMd(name: "").obs;

  var isLoading = true.obs;
  var isSearchLoading = false.obs;

  int pageSize = 10;
  RxInt currentPage = 1.obs;
  Rx<Filter> selectedFilter = Filter(type: '', value: '').obs;

  bool get isLoadingMoreEnabled =>
      products.length >= pageSize && !isLoading.value;

  @override
  void onInit() {
    super.onInit();
    PrayerTimesController.to.getBankDetails();
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
      debugPrint("Error fetching categories: $e");
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
      debugPrint("Error fetching products by category: $e");
    } finally {
      isLoading.value = false;
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
      debugPrint("Error loading more products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<ProductMd?> searchProductByBarcode(String barcode) async {
    try {
      return await ApiService().searchProductByBarcode(barcode);
    } catch (e) {
      debugPrint("Error searching product by barcode: $e");
      return null;
    }
  }

  //add product to cart by barcode
  void addProductToCartByBarcode(String barcode) async {
    ProductMd? product = await searchProductByBarcode(barcode);
    if (product != null) {
      CartController.to.addToCart(product);
    } else {
      showToast('Product not found', isWarning: true);
    }
  }
}
