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

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    String userId = SupabaseDep.impl.auth.currentUser!.id;
    List<OrderDetailsMd> orders = await ApiService().getUserOrders(userId);
    orderList.assignAll(orders);
  }
}
