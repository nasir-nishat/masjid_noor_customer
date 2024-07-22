import 'package:masjid_noor_customer/mgr/models/bank_md.dart';
import 'package:masjid_noor_customer/mgr/models/category_md.dart';
import 'package:masjid_noor_customer/mgr/models/order_item_md.dart';
import 'package:masjid_noor_customer/mgr/models/order_md.dart';
import 'package:masjid_noor_customer/mgr/models/payment_md.dart';
import 'package:masjid_noor_customer/mgr/models/product_md.dart';
import 'package:masjid_noor_customer/mgr/models/user_md.dart';
import 'package:masjid_noor_customer/presentation/pages/all_export.dart';
import 'package:masjid_noor_customer/presentation/utills/extensions.dart';
import '../dependency/supabase_dep.dart';
import '../models/feedback_md.dart';
import '../models/jamah_md.dart';
import '../models/supplier_md.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ApiException implements Exception {
  final String message;
  final String? code;

  ApiException(this.message, {this.code});

  @override
  String toString() =>
      'ApiException: $message${code != null ? ' (Code: $code)' : ''}';
}

class ApiService {
  ApiService();

  final SupabaseClient _supabaseClient = SupabaseDep.impl.supabase;

  Future<T> _handleRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on PostgrestException catch (e) {
      throw ApiException('Database error: ${e.message}', code: e.code);
    } on AuthException catch (e) {
      throw ApiException('Authentication error: ${e.message}',
          code: e.statusCode);
    } catch (e) {
      throw ApiException('Unknown error occurred: $e');
    }
  }

  // ===========================
  // ===========================
  // USER/Profile CRUD operations
  // ===========================
  // ===========================

  Future<UserMd?> getUser(String userId) async {
    return _handleRequest(() async {
      final response =
          await _supabaseClient.from('users').select("*").eq('user_id', userId);

      return response.isEmpty ? null : UserMd.fromJson(response[0]);
    });
  }

  Future<UserMd> registerUser(UserMd user) async {
    final existingUser = await getUser(user.userId!);
    if (existingUser != null) return existingUser;

    return _handleRequest(() async {
      final response = await _supabaseClient.from('users').insert({
        'user_id': user.userId,
        'email': user.email,
        'password_hash': user.passwordHash,
        'first_name': user.firstName,
        'last_name': user.lastName,
        'is_admin': false,
        'phone_number': user.phoneNumber,
        'username': user.username,
        'profile_pic': user.profilePic,
        'created_at': DateTime.now().toIso8601String(),
      }).select();

      return UserMd.fromJson(response[0]);
    });
  }

  Future updateUserPhoneNumber(String phoneNumber) async {
    return _handleRequest(() async {
      await _supabaseClient
          .from('users')
          .update({'phone_number': phoneNumber.removeAllWhitespace})
          .eq('user_id', SupabaseDep.impl.supabase.auth.currentUser!.id)
          .wait();
    });
  }

  // ===========================
  // ===========================
  // Categories CRUD operations
  // ===========================
  // ===========================
  Future<List<CategoryMd>> getCategories() async {
    return _handleRequest(() async {
      final response = await _supabaseClient.from('categories').select("*");

      return (response as List)
          .map((category) => CategoryMd.fromJson(category))
          .toList();
    });
  }

  Future<void> createCategory(CategoryMd category) async {
    await _handleRequest(() async {
      await _supabaseClient.from('categories').insert({
        'name': category.name,
        'description': category.description,
        'image': category.image,
      }).select();
    });
  }

  Future<void> updateCategory({required CategoryMd category}) async {
    await _handleRequest(() async {
      int id = int.tryParse(category.id.toString())!;
      await _supabaseClient
          .from('categories')
          .update(category.toJson())
          .eq('category_id', id);
    });
  }

  Future<void> deleteCategory(int id) async {
    await _handleRequest(() async {
      await _supabaseClient.from('categories').delete().eq('category_id', id);
    });
  }

  // ===========================
  // ===========================
  // Products CRUD operations
  // ===========================
  // ===========================

  Future<List<ProductMd>> getProducts(
      {required int from, required int to, Filter? filter}) async {
    return _handleRequest(() async {
      debugPrint("From $from To $to");
      debugPrint("Filter: ${filter?.type} ${filter?.value}");

      final response = (filter != null && filter.type.isNotEmpty)
          ? await _supabaseClient
              .from('products')
              .select("*")
              .eq(filter.type, filter.value)
              .range(from, to)
          : await _supabaseClient.from('products').select("*").range(from, to);

      return (response as List)
          .map((product) => ProductMd.fromJson(product))
          .toList();
    });
  }

  Future<void> createProduct(ProductMd product) async {
    await _handleRequest(() async {
      await _supabaseClient.from('products').insert({
        'name': product.name,
        "category_id": product.categoryId,
        'description': product.description,
        "barcode": product.barcode,
        'sell_price': product.sellPrice,
        'purchase_price': product.purchasePrice,
        "stock_qty": product.stockQty,
        "images": product.images,
        "is_new": product.isNew,
        "supp_id": product.suppId,
      }).select();
    });
  }

  Future<void> updateProduct({required ProductMd product}) async {
    await _handleRequest(() async {
      await _supabaseClient
          .from('products')
          .update(product.toJson())
          .eq('product_id', product.id!);
    });
  }

  Future<int> deleteProduct(int id) async {
    try {
      await _supabaseClient.from('products').delete().eq('product_id', id);
      return 0;
    } catch (e) {
      if (e is PostgrestException) {
        return int.tryParse(e.code ?? '') ?? -1;
      }
      return -1;
    }
  }

  Future<List<ProductMd>> searchProducts(
      String query, int limit, int page) async {
    print("Searching products for: $query");
    final response = await _supabaseClient
        .from('products')
        .select()
        .ilike('name', '%$query%')
        .range((page - 1) * limit, page * limit - 1);

    List<ProductMd> products =
        (response as List).map((item) => ProductMd.fromJson(item)).toList();
    print(products);
    return products;
  }

  // ===========================
  // ===========================
  // Order CRUD operations
  // ===========================
  // ===========================

  Future<String?> placeOrder({
    required List<CartMd> cartItems,
    required String contactNumber,
    required String userId,
    required String note,
    required PaymentMethod paymentMethod,
  }) async {
    final totalAmount = cartItems.fold<double>(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );

    try {
      // Insert into orders table
      final orderResponse = await _supabaseClient
          .from('orders')
          .insert({
            'contact_number': contactNumber,
            'total_amount': totalAmount,
            'status': 'pending',
            'note': note,
            'user_id': userId,
            'payment_method': paymentMethod.toShortString(),
          })
          .select()
          .single();

      final orderId = orderResponse['id'];

      // Insert into order_items table
      for (final item in cartItems) {
        await _supabaseClient.from('order_items').insert({
          'order_id': orderId,
          'product_id': item.product.id,
          'quantity': item.quantity,
          'unit_price': item.product.sellPrice,
          'total_price': item.totalPrice,
          'product_name': item.product.name,
        });
      }

      return orderId.toString();
    } catch (error) {
      print('Error placing order: $error');
      return null;
    }
  }

  Future<List<OrderDetailsMd>> getUserOrders(String userId) async {
    try {
      final response = await _supabaseClient.from('orders').select('''
          *,
          order_items:order_items (
            *,
            product:products (
              name
            )
          )
        ''').eq('user_id', userId).order('created_at', ascending: false).wait();

      if (response.error != null) {
        print('Error fetching orders: ${response.error!.message}');
        return [];
      }

      final ordersData = response.data as List<dynamic>?;

      if (ordersData == null) {
        return [];
      }

      List<OrderDetailsMd> orders = ordersData
          .map(
              (order) => OrderDetailsMd.fromJson(order as Map<String, dynamic>))
          .toList();

      // Print and check results
      for (var order in orders) {
        print('Order ID: ${order.id}');
        print('Contact Number: ${order.contactNumber}');
        print('Total Amount: ${order.totalAmount}');
        print('Status: ${order.status}');
        print('Note: ${order.note}');
        print('Created At: ${order.createdAt}');
        print('Updated At: ${order.updatedAt}');
        print('Payment Type: ${order.paymentType}');
        print('User ID: ${order.userId}');

        for (var item in order.items) {
          print('  Item ID: ${item.id}');
          print('  Product ID: ${item.productId ?? 'Unknown'}');
          print('  Product Name: ${item.productName}');
          print('  Quantity: ${item.quantity}');
          print('  Unit Price: ${item.unitPrice}');
          print('  Total Price: ${item.totalPrice}');
        }
      }

      return orders;
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  Future<void> updateOrderStatus(int id, String status) async {
    await _handleRequest(() async {
      await _supabaseClient
          .from('orders')
          .update({'status': status}).eq('order_id', id);
    });
  }

  Future<void> deleteOrder(int id) async {
    await _handleRequest(() async {
      await _supabaseClient.from('orders').delete().eq('order_id', id);
    });
  }

  //getOrderItems
  Future<List<OrderItemMd>> getOrderItems(int orderId) async {
    return _handleRequest(() async {
      final response = await _supabaseClient
          .from('order_items')
          .select("*")
          .eq('order_id', orderId);

      return (response as List)
          .map((orderItem) => OrderItemMd.fromJson(orderItem))
          .toList();
    });
  }

  // ===========================
  // ===========================
  // Jamah operations
  // ===========================
  // ===========================
  Future<JamahMd> getJamahTime(int id) async {
    return _handleRequest(() async {
      final response =
          await _supabaseClient.from('jamah_times').select("*").eq("id", id);

      print(response);
      return JamahMd.fromJson(response[0]);
    });
  }

  Future<BankMd> getBank(int id) async {
    return _handleRequest(() async {
      final response =
          await _supabaseClient.from('banks').select("*").eq("id", id);

      print(response);
      return BankMd.fromJson(response[0]);
    });
  }

  // ===========================
  // ===========================
  // Supplier operations
  // ===========================
  // ===========================
  Future<List<SupplierMd>> getSuppliers() async {
    return _handleRequest(() async {
      final response = await _supabaseClient.from('suppliers').select("*");

      return (response as List)
          .map((supplier) => SupplierMd.fromJson(supplier))
          .toList();
    });
  }

  Future<void> createSupplier(SupplierMd supplier) async {
    await _handleRequest(() async {
      await _supabaseClient.from('suppliers').insert({
        'name': supplier.name,
        'address': supplier.address,
        'phone': supplier.phone,
        'email': supplier.email,
        'note': supplier.note,
      }).select();
    });
  }

  Future<void> updateSupplier(SupplierMd supplier) async {
    if (supplier.id == null) return;
    await _handleRequest(() async {
      await _supabaseClient
          .from('suppliers')
          .update(supplier.toJson())
          .eq('id', supplier.id!);
    });
  }

  Future<int?> deleteSupplier(int id) async {
    try {
      // await _supabaseClient.from('suppliers').delete().eq('id', id);
      //update is_active to false
      await _supabaseClient
          .from('suppliers')
          .update({"is_active": false}).eq('id', id);
      return 0;
    } catch (e) {
      if (e is PostgrestException) {
        return int.tryParse(e.code ?? '') ?? -1;
      }
      return -1;
    }
  }

  // ===========================
  // ===========================
  // Feedback operations
  // ===========================
  // ===========================
  Future<List<FeedbackMd>> getFeedbacks() async {
    return _handleRequest(() async {
      final response = await _supabaseClient.from('feedbacks').select("*");

      return (response as List)
          .map((feedback) => FeedbackMd.fromJson(feedback))
          .toList();
    });
  }

  Future<bool> sendFeedback(FeedbackMd feedback) async {
    return _handleRequest(() async {
      final response = await _supabaseClient.from('feedbacks').insert({
        'feedback': feedback.feedback,
        'user_id': feedback.userId,
        'rating': feedback.rating,
        'image_url': feedback.imageUrl,
      }).select();

      return response.isNotEmpty;
    });
  }

  // ===========================
  // ===========================
  // GET Count of all table
  // ===========================
  // ===========================
  Future<int> getProductsCount({Filter? filter}) async {
    return _handleRequest(() async {
      bool isFiltering = filter != null && filter.type.isNotEmpty;

      if (isFiltering) {
        PostgrestResponse? res = await _supabaseClient
            .from('products')
            .select("*")
            .eq(filter.type, filter.value)
            .count();

        return res.count;
      }
      final response = await _supabaseClient.from('products').count();
      return response;
    });
  }

  Future<int> getOrdersCount({Filter? filter}) async {
    return _handleRequest(() async {
      bool isFiltering = filter != null && filter.type.isNotEmpty;

      if (isFiltering) {
        PostgrestResponse? res = await _supabaseClient
            .from('orders')
            .select("*")
            .eq(filter.type, filter.value)
            .count();

        return res.count;
      }
      final response = await _supabaseClient.from('orders').count();
      return response;
    });
  }

  // ===========================
  // ===========================
  // GET CASE INSENSITIVE search
  // ===========================
  // ===========================

  Future<List<ProductMd>> searchProduct({required String prodName}) async {
    return _handleRequest(() async {
      final response = await _supabaseClient
          .from('products')
          .select("*")
          .ilike('product_name', '%$prodName%');

      return (response as List)
          .map((product) => ProductMd.fromJson(product))
          .toList();
    });
  }

  Future<ProductMd?> searchProductByBarcode(String barcode) async {
    return _handleRequest(() async {
      final response = await _supabaseClient
          .from('products')
          .select("*")
          .eq('barcode', barcode);

      return ProductMd.fromJson(response[0]);
    });
  }

  // ===========================
  // ===========================
  // CRUD Images from Supabase bucket
  // ===========================
  // ===========================
  Future<String?> uploadAndGetUrl(
      {required Uint8List data,
      required String name,
      required ImageType type}) async {
    return _handleRequest(() async {
      final path = await SupabaseDep.impl
          .uploadAFile(data: data, name: name, type: type);
      if (path == null) {
        return null;
      }
      return SupabaseDep.impl.getPublicUrl(path);
    });
  }

  //delete images from supabase bucket
  Future<void> deleteImage(String path) async {
    await _handleRequest(() async {
      await SupabaseDep.impl.deleteFile(path);
    });
  }
}

class Filter {
  final String type;
  final dynamic value;

  Filter({required this.type, required this.value});
}
