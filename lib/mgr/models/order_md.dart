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

class OrderMd extends Equatable {
  final int? id;
  final DateTime? orderDate;
  final double? totalAmount;
  OrderStatusType? status;
  final String? note;
  final String? contactNumber;

  OrderMd(
      {this.id,
      this.orderDate,
      this.totalAmount,
      this.status,
      this.note,
      this.contactNumber});

  @override
  List<Object?> get props => [
        id,
        orderDate,
        totalAmount,
        status,
        note,
        contactNumber,
      ];

  factory OrderMd.fromJson(Map<String, dynamic> json) {
    try {
      return OrderMd(
        id: json['order_id'],
        orderDate: DateTime.parse(json['order_date']),
        totalAmount: (json['total_amount'] as num) as double,
        status: json['status'] != null
            ? ParseToString.fromString(json['status'])
            : null,
        note: json['note'],
        contactNumber: json['contact_number'],
      );
    } on TypeError catch (e, st) {
      print("Type Error: $e\nStack Trace: $st");
      rethrow;
    } catch (e, st) {
      print("Error: $e\nStack Trace: $st");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_date': orderDate?.toIso8601String(),
      'total_amount': totalAmount,
      'status': status?.toShortString(),
      'note': note,
      'contact_number': contactNumber,
    };
  }

  void updateStatus(OrderStatusType newStatus) {
    status = newStatus;
  }
}
