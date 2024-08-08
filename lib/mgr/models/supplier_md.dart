import 'package:equatable/equatable.dart';import 'package:flutter/material.dart';class SupplierMd extends Equatable {  final int? id;  final String? name;  final String? address;  final String? phone;  final String? email;  final String? note;  final bool? isActive;  const SupplierMd({    this.id,    this.name,    this.address,    this.phone,    this.email,    this.note,    this.isActive,  });  @override  List<Object?> get props => [        id,        name,        address,        phone,        email,        note,        isActive,      ];  factory SupplierMd.fromJson(Map<String, dynamic> json) {    try {      return SupplierMd(        id: json['id'],        name: json['name'],        address: json['address'],        phone: json['phone'],        email: json['email'],        note: json['note'],        isActive: json['is_active'],      );    } on TypeError catch (e, st) {      debugPrint("Error: $e, $st");      rethrow;    }  }  Map<String, dynamic> toJson() {    return {      'id': id,      'name': name,      'address': address,      'phone': phone,      'email': email,      'note': note,      'is_active': isActive,    };  }}