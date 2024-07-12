import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_noor_customer/mgr/models/order_md.dart';
import 'package:masjid_noor_customer/presentation/pages/order/order_controller.dart';

class OrdersPage extends GetView<OrderController> {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.orderList.length,
          itemBuilder: (context, index) {
            final order = controller.orderList[index];
            return ListTile(
              title: Text(
                  'Order #${order.id} - ${order.status.toShortString().capitalize}'),
              subtitle: Text(
                  'Total Amount: \$${order.totalAmount.toStringAsFixed(2)}'),
              onTap: () => _showOrderDetailsMdDialog(context, order),
            );
          },
        ),
      ),
    );
  }

  void _showOrderDetailsMdDialog(BuildContext context, OrderDetailsMd order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Order #${order.id}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contact Number: ${order.contactNumber}'),
                Text('Status: ${order.status}'),
                Text('Note: ${order.note}'),
                const SizedBox(height: 10),
                const Text('Items:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...order.items.map((item) => ListTile(
                      title: Text('Product ID: ${item.productId}'),
                      subtitle: Text(
                          'Quantity: ${item.quantity}, Unit Price: \$${item.unitPrice}, Total: \$${item.totalPrice}'),
                    )),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
