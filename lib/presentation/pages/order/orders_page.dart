import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:masjid_noor_customer/mgr/models/order_md.dart';
import 'package:masjid_noor_customer/presentation/pages/order/order_controller.dart';
import 'package:masjid_noor_customer/presentation/widgets/order_status.dart';

class OrdersPage extends GetView<OrderController> {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart',
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
      ),
      body: controller.orderList.isEmpty
          ? const Center(child: Text('No orders found'))
          : Obx(
              () => Padding(
                padding: EdgeInsets.all(8.w),
                child: controller.isLoadingOrders.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        itemCount: controller.orderList.length,
                        itemBuilder: (context, index) {
                          final order = controller.orderList[index];
                          return ListTile(
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order #${order.id} \nTotal Amount: \$${order.totalAmount.toStringAsFixed(2)}',
                                ),
                                OrderStatusWidget(status: order.status),
                              ],
                            ),
                            onTap: () =>
                                _showOrderDetailsBottomSheet(context, order),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                          thickness: .5.h,
                          height: .5.h,
                          color: Colors.grey[300],
                        ),
                      ),
              ),
            ),
    );
  }

  void _showOrderDetailsBottomSheet(
      BuildContext context, OrderDetailsMd order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: InkWell(
              //       onTap: () {
              //         Navigator.of(context).pop();
              //       },
              //       child: const HeroIcon(HeroIcons.xMark)),
              // ),
              Align(
                alignment: Alignment.center,
                child: Container(
                    width: 50.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.r),
                    )),
              ),
              SizedBox(height: 10.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.id}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                  ),
                  OrderStatusWidget(status: order.status)
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                'Total Amount: \$${order.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Items:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                      SizedBox(height: 10.h),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.items.length,
                        itemBuilder: (context, index) {
                          final item = order.items[index];
                          return ListTile(
                            title: Text(item.productName,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              'Quantity: ${item.quantity}, Unit Price: \$${item.unitPrice.toStringAsFixed(2)}, Total: \$${item.totalPrice.toStringAsFixed(2)}',
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                          thickness: .5.h,
                          height: .5.h,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
