import 'package:masjid_noor_customer/presentation/pages/all_export.dart';

import 'order_controller.dart';

class OrderDetailsMdPage extends GetView<OrderController> {
  const OrderDetailsMdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: controller.orderList.length,
        itemBuilder: (context, index) {
          final payment = controller.orderList[index];
        },
      ),
    );
  }
}
