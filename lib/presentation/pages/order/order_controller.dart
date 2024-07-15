import 'package:get/get.dart';
import 'package:masjid_noor_customer/mgr/dependency/supabase_dep.dart';
import 'package:masjid_noor_customer/mgr/models/order_md.dart';
import 'package:masjid_noor_customer/mgr/services/api_service.dart';

class OrderController extends GetxController {
  static OrderController get to {
    if (!Get.isRegistered<OrderController>()) {
      Get.lazyPut<OrderController>(() => OrderController());
    }
    return Get.find<OrderController>();
  }

  var orderList = <OrderDetailsMd>[].obs;
  var filteredOrderList = <OrderDetailsMd>[].obs;
  RxBool isLoadingOrders = false.obs;
  var orderStatuses =
      ['All', 'Pending', 'Processing', 'Completed', 'Cancelled'].obs;
  var selectedStatus = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    isLoadingOrders.value = true;
    String userId = SupabaseDep.impl.auth.currentUser!.id;
    List<OrderDetailsMd> orders = await ApiService().getUserOrders(userId);
    orderList.assignAll(orders);
    isLoadingOrders.value = false;
    filteredOrderList.assignAll(orderList);
  }

  filterOrders(String status) {
    selectedStatus.value = status;
    if (status == 'All') {
      filteredOrderList.assignAll(orderList);
    } else {
      filteredOrderList.assignAll(orderList
          .where((element) =>
              element.status.toShortString().contains(status.toLowerCase()))
          .toList());
    }
  }
}
