import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';

class CategoriesSection extends GetView<ProductController> {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: Colors.grey[100],
      child: Obx(() => ListView.builder(
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return Obx(() => Container(
                    decoration: BoxDecoration(
                      color: controller.selectedCategory.value == category
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.transparent,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        category.name,
                        style: TextStyle(
                          fontWeight:
                              controller.selectedCategory.value == category
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        controller.selectedCategory.value = category;
                        controller.fetchProductsByCategory();
                      },
                      trailing: Icon(
                        Icons.chevron_right,
                        color: controller.selectedCategory.value == category
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ),
                  ));
            },
          )),
    );
  }
}
