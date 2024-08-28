import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'kiosk_widgets/categories_section.dart';
import 'kiosk_widgets/item_list_section.dart';
import 'kiosk_widgets/order_section.dart';

class KioskView extends StatelessWidget {
  const KioskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: const Row(
          children: [
            Expanded(flex: 1, child: CategoriesSection()),
            Expanded(flex: 4, child: ItemsListSection()),
            Expanded(flex: 2, child: OrderSection()),
          ],
        ),
      ),
    );
  }
}
