import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class ApiEndpoints {
  ApiEndpoints._();

  static String get defaultBaseUrl {

    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty) return envUrl;

    // Web (Chrome) için
    if (kIsWeb) {
      return 'http://localhost:3000/api/v1';
    }

    // Android Cihazlar (Fiziki Telefon & Emülatör) için
    if (Platform.isAndroid) {
      return 'http://192.168.1.104:3000/api/v1';
    }

    // iOS Simülatör / Masaüstü varsayılanı
    return 'http://localhost:3000/api/v1';
  }

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Users
  static const String me = '/users/me';
  static const String profile = '/users/profile'; 
  // Categories
  static const String categories = '/categories';

  // Products
  static const String products = '/products';
  static String productDetail(String id) => '/products/$id';

  // Cart
  static const String cart = '/cart';

  // Orders
  static const String orders = '/orders';
  static String orderDetail(String id) => '/orders/$id'; 

  // Favorites
  static const String favorites = '/favorites';
}