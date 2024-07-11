import 'package:equatable/equatable.dart';class UserMd extends Equatable {  String? userId;  String email;  String? passwordHash;  String? firstName;  String? lastName;  bool? isAdmin;  DateTime createdAt;  String phoneNumber;  String? username;  String? profilePic;  UserMd({    this.userId,    required this.email,    this.passwordHash,    this.firstName,    this.lastName,    this.isAdmin,    required this.createdAt,    required this.phoneNumber,    this.username,    this.profilePic,  });  @override  List<Object?> get props => [        userId,        email,        passwordHash,        firstName,        lastName,        isAdmin,        createdAt,        phoneNumber,        username,        profilePic,      ];  factory UserMd.fromJson(Map<String, dynamic> json) {    try {      return UserMd(        userId: json['user_id'],        email: json['email'],        passwordHash: json['password_hash'],        firstName: json['first_name'],        lastName: json['last_name'],        isAdmin: json['is_admin'],        createdAt: DateTime.parse(json['created_at']),        phoneNumber: json['phone_number'],        username: json['username'],        profilePic: json['profile_pic'],      );    } on TypeError catch (e, st) {      print("Error: $e, $st");      rethrow;    }  }  Map<String, dynamic> toJson() {    return {      'user_id': userId,      'email': email,      'password_hash': passwordHash,      'first_name': firstName,      'last_name': lastName,      'is_admin': isAdmin,      'created_at': createdAt.toIso8601String(),      'phone_number': phoneNumber,      'username': username,      'profile_pic': profilePic,    };  }}