import 'package:equatable/equatable.dart';

class ProductMd extends Equatable {
  int? id;
  int? categoryId;
  String name;
  double sellPrice;
  String? description;
  int? stockQty;
  List? images;
  double? purchasePrice;
  String? barcode;

  // double? discount;
  // DateTime? startDate;
  // DateTime? endDate;
  bool? isNew;
  bool? isPopular;
  int? suppId;
  int? cartQty;

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
    this.isPopular,
    this.suppId,
    this.cartQty,
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
        isPopular,
        suppId,
        cartQty,
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
        isPopular: json['is_popular'],
        suppId: json['supp_id'],
        cartQty: json['cart_qty'],
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
      'is_popular': isPopular,
      'supp_id': suppId,
      'cart_qty': cartQty,
    };
  }

  ProductMd copyWith({
    int? id,
    int? categoryId,
    String? name,
    String? description,
    int? stockQty,
    List? images,
    double? sellPrice,
    double? purchasePrice,
    String? barcode,
    // double? discount,
    // DateTime? startDate,
    // DateTime? endDate,
    bool? isNew,
    bool? isPopular,
    int? suppId,
    int? cartQty,
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
      isPopular: isPopular ?? this.isPopular,
      suppId: suppId ?? this.suppId,
      cartQty: cartQty ?? this.cartQty,
    );
  }
}
