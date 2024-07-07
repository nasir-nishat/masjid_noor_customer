import 'package:equatable/equatable.dart';

class CategoryMd extends Equatable {
  int? id;
  String name;
  String? description;
  String? image;
  bool? isActive;

  CategoryMd({
    this.id,
    required this.name,
    this.description,
    this.image,
    this.isActive,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        image,
        isActive,
      ];

  factory CategoryMd.fromJson(Map<String, dynamic> json) {
    try {
      return CategoryMd(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        image: json['image'],
        isActive: json['is_active'],
      );
    } on TypeError catch (e, st) {
      print("Error: $e, $st");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'is_active': isActive,
    };
  }
}
