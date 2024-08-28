import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/kiosk_controller.dart';
import 'kiosk_widgets/categories_section.dart';
import 'kiosk_widgets/item_list_section.dart';
import 'kiosk_widgets/order_section.dart';

class KioskView extends GetView<KioskController> {
  const KioskView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('An-Noor Kiosk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              // TODO: Implement scanning functionality
            },
          ),
        ],
      ),
      body: const Row(
        children: [
          Expanded(flex: 1, child: CategoriesSection()),
          Expanded(flex: 2, child: ItemsListSection()),
          Expanded(flex: 1, child: OrderSection()),
        ],
      ),
    );
  }
}
