import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ProductMd extends Equatable {
  final int? id;
  final int? categoryId;
  final String name;
  final double sellPrice;
  final String? description;
  final int? stockQty;
  final List<String>? images;
  final double? purchasePrice;
  final String? barcode;

  // double? discount;
  // DateTime? startDate;
  // DateTime? endDate;
  final bool? isNew;
  final int? suppId;
  final bool? isActive;
  final bool? isPopular;

  const ProductMd({
    this.id,
    this.categoryId,
    required this.name,
    this.description,
    this.stockQty,
    this.images,
    required this.sellPrice,
    this.purchasePrice,
    this.barcode,
    // this.discount,
    // this.startDate,
    // this.endDate,
    this.isNew,
    this.suppId,
    this.isActive,
    this.isPopular,
  });

  @override
  List<Object?> get props => [
        id,
        categoryId,
        name,
        description,
        stockQty,
        images,
        sellPrice,
        purchasePrice,
        barcode,
        // discount,
        // startDate,
        // endDate,
        isNew,
        suppId,
        isActive,
        isPopular,
      ];

  factory ProductMd.fromJson(Map<String, dynamic> json) {
    try {
      return ProductMd(
        id: json['id'],
        categoryId: json['category_id'],
        name: json['name'],
        description: json['description'],
        stockQty: json['stock_qty'],
        images: json['images'] != null
            ? List<String>.from(json['images'].map((x) => x))
            : [],
        sellPrice: json['sell_price'],
        purchasePrice: json['purchase_price'],
        barcode: json['barcode'],
        // discount: json['discount'],
        // startDate: json['start_date'],
        // endDate: json['end_date'],
        isNew: json['is_new'],
        suppId: json['supp_id'],
        isActive: json['is_active'],
        isPopular: json['is_popular'],
      );
    } on TypeError catch (e, st) {
      debugPrint("Error: $e, $st");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final data = {
      'category_id': categoryId,
      'name': name,
      'description': description,
      'stock_qty': stockQty,
      'images': images != null ? List<dynamic>.from(images!.map((x) => x)) : [],
      'sell_price': sellPrice,
      'purchase_price': purchasePrice,
      'barcode': barcode,
      'is_new': isNew,
      'supp_id': suppId,
      'is_active': isActive,
      'is_popular': isPopular,
    };

    // Only add 'id' if it is not null
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }

  //copy with
  ProductMd copyWith({
    int? id,
    int? categoryId,
    String? name,
    String? description,
    int? stockQty,
    List<String>? images,
    double? sellPrice,
    double? purchasePrice,
    String? barcode,
    // double? discount,
    // DateTime? startDate,
    // DateTime? endDate,
    bool? isNew,
    int? suppId,
    bool? isActive,
    bool? isPopular,
  }) {
    return ProductMd(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      stockQty: stockQty ?? this.stockQty,
      images: images ?? this.images,
      sellPrice: sellPrice ?? this.sellPrice,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      barcode: barcode ?? this.barcode,
      // discount: discount ?? this.discount,
      // startDate: startDate ?? this.startDate,
      // endDate: endDate ?? this.endDate,
      isNew: isNew ?? this.isNew,
      suppId: suppId ?? this.suppId,
      isActive: isActive ?? this.isActive,
      isPopular: isPopular ?? this.isPopular,
    );
  }
}
