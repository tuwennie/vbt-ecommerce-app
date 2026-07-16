/// Kaynak: backend/docs/openapi.yaml (v1.1.0)
/// Base URL'i asla hardcode etme; `--dart-define=API_BASE_URL=...` ile geç.
/// Örn: flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1
class ApiEndpoints {
  ApiEndpoints._();

  static const String defaultBaseUrl = 'http://10.0.2.2:3000/api/v1';
  // Not: Android emülatörde localhost yerine 10.0.2.2 kullanılır.
  // iOS simülatörde http://localhost:3000/api/v1 çalışır.

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Users
  static const String me = '/users/me';

  // Categories
  static const String categories = '/categories';

  // Products
  static const String products = '/products';
  static String productDetail(String id) => '/products/$id';

  // Cart
  static const String cart = '/cart';

  // Orders
  static const String orders = '/orders';

  // Favorites
  static const String favorites = '/favorites';
}
