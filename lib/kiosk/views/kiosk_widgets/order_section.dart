// lib/app/modules/kiosk/views/widgets/order_section.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_noor_customer/kiosk/views/controllers/kiosk_controller.dart';

class OrderSection extends GetView<KioskController> {
  const OrderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 3, // Replace with actual order item count
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Order Item ${index + 1}'),
                  subtitle: Text('\$${(index + 1) * 5}.99'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      // TODO: Implement remove from order functionality
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Total: \$50.97',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement order confirmation
                    _showPhoneNumberDialog(context);
                  },
                  child: Text('Confirm Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPhoneNumberDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('Enter Phone Number'),
        content: TextField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'Phone Number',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement phone number submission
              Get.back();
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
