import 'package:masjid_noor_customer/mgr/models/payment_md.dart';

// Enum for order status types
enum OrderStatus {
  pending,
  processing,
  completed,
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

class OrderDetailsMd {
  final int id;
  final String contactNumber;
  final double totalAmount;
  final OrderStatus status;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PaymentMethod paymentType;
  final String userId;
  final List<OrderItemDetailsMd> items;

  OrderDetailsMd({
    required this.id,
    required this.contactNumber,
    required this.totalAmount,
    required this.status,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    required this.paymentType,
    required this.userId,
  });

  factory OrderDetailsMd.fromJson(Map<String, dynamic> json) {
    return OrderDetailsMd(
      id: json['id'] as int? ?? 0,
      contactNumber: json['contact_number'] as String? ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      note: json['note'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.now(),
      items: (json['order_items'] as List<dynamic>?)
              ?.map(
                  (e) => OrderItemDetailsMd.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      status: OrderStatusParseToString.fromString(
          json['status'] as String? ?? 'pending'),
      paymentType: PaymentMethodParseToString.fromString(
          json['payment_type'] as String? ?? 'cash'),
      userId: json['user_id'] as String? ?? '',
    );
  }
}

class OrderItemDetailsMd {
  final int id;
  final int orderId;
  final int? productId; // Changed to int?
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String productName;

  OrderItemDetailsMd({
    required this.id,
    required this.orderId,
    this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.productName,
  });

  factory OrderItemDetailsMd.fromJson(Map<String, dynamic> json) {
    return OrderItemDetailsMd(
      id: json['id'] as int? ?? 0,
      orderId: json['order_id'] as int? ?? 0,
      productId: json['product_id'] as int?, // Changed to int?
      quantity: json['quantity'] as int? ?? 0,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      productName: json['product_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId, // Allow null
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'product_name': productName,
    };
  }
}
