
// lib/app/modules/kiosk/views/widgets/categories_section.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_noor_customer/kiosk/views/controllers/kiosk_controller.dart';

class CategoriesSection extends GetView<KioskController> {
  const CategoriesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: ListView.builder(
        itemCount: 5, // Replace with actual category count
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Category ${index + 1}'),
            onTap: () {
              // TODO: Implement category selection
            },
          );
        },
      ),
    );
  }
}