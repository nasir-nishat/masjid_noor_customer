import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:masjid_noor_customer/presentation/pages/order/order_controller.dart';

class OrdersPage extends GetView<OrderController> {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => ListView.builder(
        itemCount: controller.orderList.length,
        itemBuilder: (context, index) {
          final payment = controller.orderList[index];
          return ListTile(
            title: Text(payment.name),
            subtitle: Text(payment.description),
            trailing: Text(payment.price.toString()),
          );
        },
      ),
    ));
  }
}
