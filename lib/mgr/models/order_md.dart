import 'package:masjid_noor_customer/mgr/models/payment_md.dart';

// Enum for order status types
enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}

extension OrderStatusParseToString on OrderStatus {
  String toShortString() {
    return toString().split('.').last;
  }

  static OrderStatus fromString(String status) {
    return OrderStatus.values.firstWhere(
      (e) => e.toShortString() == status,
      orElse: () => OrderStatus.pending,
    );
  }
}

class OrderDetails {
  final int id;
  final String contactNumber;
  final double totalAmount;
  final String status;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PaymentMethod paymentType;
  final OrderStatus orderStatus;
  final String userId;
  final List<OrderItemDetails> items;

  OrderDetails({
    required this.id,
    required this.contactNumber,
    required this.totalAmount,
    required this.status,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    required this.paymentType,
    required this.orderStatus,
    required this.userId,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      id: json['id'],
      contactNumber: json['contact_number'],
      totalAmount: json['total_amount'],
      status: json['status'],
      note: json['note'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      // items: (json['items'] as List)
      //     .map((e) => OrderItemDetails.fromJson(e))
      //     .toList(),
      items: (json['order_items'] as List?)
              ?.map((e) => OrderItemDetails.fromJson(e))
              .toList() ??
          [],

      orderStatus: OrderStatusParseToString.fromString(json['order_status']),
      paymentType:
          PaymentMethodParseToString.fromString(json['payment_type'] ?? 'cash'),
      userId: json['user_id'],
    );
  }
}

class OrderItemDetails {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  OrderItemDetails({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItemDetails.fromJson(Map<String, dynamic> json) {
    return OrderItemDetails(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      unitPrice: double.parse(json['unit_price'].toString()),
      totalPrice: double.parse(json['total_price'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
    };
  }
}
