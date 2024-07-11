import 'package:get/get.dart';
import 'package:masjid_noor_customer/mgr/dependency/supabase_dep.dart';
import 'package:masjid_noor_customer/mgr/models/order_md.dart';

class OrderController extends GetxController {
  static OrderController get to {
    if (!Get.isRegistered<OrderController>()) {
      Get.lazyPut<OrderController>(() => OrderController());
    }
    return Get.find<OrderController>();
  }

  var orderList = <OrderDetails>[].obs;
  final SupabaseService _supabaseService = SupabaseService();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final orders = await _supabaseService.getOrders();
      orderList.assignAll(orders);
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }
}

class SupabaseService {
  final _supabaseClient = SupabaseDep.impl.supabase;

  Future<List<OrderDetails>> getOrders() async {
    final response =
        await _supabaseClient.from('orders').select('*, order_items(*)');

    // if (response.error != null) {
    //   throw response.error!;
    // }

    return (response as List)
        .map((json) => OrderDetails.fromJson(json))
        .toList();
  }
}
