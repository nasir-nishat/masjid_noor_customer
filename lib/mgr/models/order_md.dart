import 'package:equatable/equatable.dart';

// Enum for order status types
enum OrderStatusType {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}

// Extension to parse string to OrderStatusType enum
extension ParseToString on OrderStatusType {
  String toShortString() {
    return toString().split('.').last;
  }

  static OrderStatusType fromString(String status) {
    return OrderStatusType.values.firstWhere(
      (e) => e.toShortString() == status,
      orElse: () => OrderStatusType.pending,
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
      items: (json['items'] as List)
          .map((item) => OrderItemDetails.fromJson(item))
          .toList(),
    );
  }
}

class OrderItemDetails {
  final int id;
  final int productId;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  OrderItemDetails({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItemDetails.fromJson(Map<String, dynamic> json) {
    return OrderItemDetails(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'],
      totalPrice: json['total_price'],
    );
  }
}
