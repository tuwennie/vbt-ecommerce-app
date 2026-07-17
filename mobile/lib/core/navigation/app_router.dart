import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/products/presentation/screens/product_list_screen.dart';
import '../../features/products/presentation/screens/product_detail_screen.dart';
import 'main_scaffold.dart';

// Geçici boş sekmeler (İleride doldurulacak placeholder ekranlar)
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text(title)));
}

class AppRouter {
  // Rota İsimleri
  static const String login = '/login';
  static const String register = '/register';
  static const String productList = '/products';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String favorites = '/favorites';
  static const String profile = '/profile';

  // Global navigasyon anahtarı
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: login, // İlk açılışta Tuba'nın Giriş ekranı gelsin
    routes: [
      // Auth Rotaları (Alt bar görünmeyecek olan bağımsız ekranlar)
      GoRoute(
        path: login,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Ürün Detay (Alt barın üstünü kaplaması için rootNavigatorKey ile açıyoruz)
      GoRoute(
        path: productDetail,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ProductDetailScreen(
            productId: extra?['productId'] ?? '',
            title: extra?['title'] ?? 'Ürün Detayı',
          );
        },
      ),

      // Tuba'nın BottomNavBar tasarımını içeren sekmeli yapı (ShellRoute)
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: productList,
            builder: (context, state) => const ProductListScreen(),
          ),
          GoRoute(
            path: cart,
            builder: (context, state) => const PlaceholderScreen(title: 'Sepetim Ekranı'),
          ),
          GoRoute(
            path: favorites,
            builder: (context, state) => const PlaceholderScreen(title: 'Favorilerim Ekranı'),
          ),
          GoRoute(
            path: profile,
            builder: (context, state) => const PlaceholderScreen(title: 'Profilim Ekranı'),
          ),
        ],
      ),
    ],
  );
}