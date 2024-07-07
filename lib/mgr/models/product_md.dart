import 'package:equatable/equatable.dart';

class ProductMd extends Equatable {
  int? id;
  int? categoryId;
  String name;
  double? sellPrice;
  String? description;
  int? stockQty;
  List? images;
  double? purchasePrice;
  String? barcode;

  // double? discount;
  // DateTime? startDate;
  // DateTime? endDate;
  bool? isNew;
  int? suppId;

  ProductMd({
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
      ];

  factory ProductMd.fromJson(Map<String, dynamic> json) {
    try {
      return ProductMd(
        id: json['id'],
        categoryId: json['category_id'],
        name: json['name'],
        description: json['description'],
        stockQty: json['stock_qty'],
        images: json['images'],
        sellPrice: json['sell_price'],
        purchasePrice: json['purchase_price'],
        barcode: json['barcode'],
        // discount: json['discount'],
        // startDate: json['start_date'],
        // endDate: json['end_date'],
        isNew: json['is_new'],
        suppId: json['supp_id'],
      );
    } on TypeError catch (e, st) {
      print("Error: $e, $st");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'stock_qty': stockQty,
      'images': images,
      'sell_price': sellPrice,
      'purchase_price': purchasePrice,
      'barcode': barcode,
      // 'discount': discount,
      // 'start_date': startDate,
      // 'end_date': endDate,
      'is_new': isNew,
      'supp_id': suppId,
    };
  }
}
