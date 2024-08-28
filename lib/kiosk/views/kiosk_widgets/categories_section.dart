import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:masjid_noor_customer/presentation/pages/product/product_controller.dart';

class CategoriesSection extends GetView<ProductController> {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Obx(() => ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 4.h),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return Obx(() => Container(
                    decoration: BoxDecoration(
                      color: controller.selectedCategory.value == category
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4.r),
                        bottomRight: Radius.circular(4.r),
                      ),
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4.r),
                          bottomRight: Radius.circular(4.r),
                        ),
                      ),
                      title: Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 14.sp,
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
