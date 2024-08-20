// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/product_md.dart';

// CreateGO supabase
const _SUPABASE_URL = "https://nsyflgowjqaunfbechqh.supabase.co";
const _SUPABASE_ANON_KEY =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5zeWZsZ293anFhdW5mYmVjaHFoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTk5OTU5MjEsImV4cCI6MjAzNTU3MTkyMX0.7DBJ7mEdcvxzGI1qj4OwbpugWUc_kcVCv3AVIXjdfag";

const GOOGLE_WEB_CLIENT_ID =
    '1075918505837-73v37dovbq6tna0hj43kfn2iivsuf2hf.apps.googleusercontent.com';

class SupabaseDep {
  //create a singleton
  static final SupabaseDep _instance = SupabaseDep._internal();

  factory SupabaseDep() => _instance;

  SupabaseDep._internal();

  static SupabaseDep get impl => _instance;

  final String _bucketName = 'default_bucket';

  late final SupabaseClient supabase;

  GoTrueClient get auth => supabase.auth;

  SupabaseStorageClient get storage => supabase.storage;

  StorageFileApi get defaultBucket => storage.from(_bucketName);

  User? get currentUser => auth.currentUser;

  //Projects table
  SupabaseQueryBuilder get products => supabase.from(Tables.products);

  //Profiles table
  SupabaseQueryBuilder get profiles => supabase.from(Tables.profiles);

  SupabaseQueryBuilder get userAssets => supabase.from(Tables.userAssets);

  List<ProductMd> productsFromJson(List<dynamic> data) {
    return data.map((e) => ProductMd.fromJson(e)).toList();
  }

  Future<void> initialize() async {
    EquatableConfig.stringify = true;

    const String url = _SUPABASE_URL;
    const String anonKey = _SUPABASE_ANON_KEY;

    if (url.isEmpty || anonKey.isEmpty) {
      throw Exception(
          "Supabase url or anon key is empty\n Check env variables if release mode");
    }
    await Supabase.initialize(
        url: url,
        anonKey: anonKey,
        realtimeClientOptions: const RealtimeClientOptions(eventsPerSecond: 2));
    supabase = Supabase.instance.client;
  }

  ///returns a path
  Future<String?> uploadAFile(
      {required Uint8List data,
      required String name,
      required ImageType type}) async {
    String getPath() {
      if (type == ImageType.product) {
        return 'public/product_images/$name';
      } else if (type == ImageType.category) {
        return 'public/category_images/$name';
      } else {
        return 'public/inventory_images/$name';
      }
    }

    try {
      final String path = await defaultBucket.uploadBinary(getPath(), data,
          fileOptions: const FileOptions(upsert: true));
      return path;
    } on StorageException catch (e) {
      debugPrint("SupabaseDep.uploadAFile");
      debugPrint(e.toString());
      debugPrint("SupabaseDep.uploadAFile");
      return null;
    }
  }

  ///returns a url
  String? getPublicUrl(String path) {
    try {
      final String url =
          defaultBucket.getPublicUrl(path).replaceFirst("/$_bucketName", "");
      return url;
    } on StorageException catch (e) {
      debugPrint("SupabaseDep.getPublicUrl");
      debugPrint(e.toString());
      debugPrint("SupabaseDep.getPublicUrl");
      return null;
    }
  }

  deleteFile(String path) async {
    try {
      await defaultBucket.remove([path]);
    } on StorageException catch (e) {
      debugPrint("SupabaseDep.deleteFile");
      debugPrint(e.toString());
      debugPrint("SupabaseDep.deleteFile");
    }
  }
}

abstract class Tables {
  static const String products = "products";
  static const String profiles = "profiles";
  static const String userAssets = "user_assets";
}

enum ImageType {
  product,
  category,
  inventory,
}
