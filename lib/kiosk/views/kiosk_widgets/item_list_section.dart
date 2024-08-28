import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_noor_customer/kiosk/views/controllers/kiosk_controller.dart';

class ItemsListSection extends GetView<KioskController> {
  const ItemsListSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemCount: 20, // Replace with actual item count
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fastfood, size: 48),
              Text('Item ${index + 1}'),
              Text('\$${(index + 1) * 5}.99'),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement add to order functionality
                },
                child: Text('Add to Order'),
              ),
            ],
          ),
        );
      },
    );
  }
}
