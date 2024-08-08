import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CategoryMd extends Equatable {
  final int? id;
  final String name;
  final String? description;
  final String? image;
  final bool? isActive;

  const CategoryMd({
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
      debugPrint("Error: $e, $st");
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
