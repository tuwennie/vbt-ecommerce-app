import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/products/presentation/screens/product_list_screen.dart';
import '../../features/products/presentation/screens/product_detail_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/categories/presentation/screens/category_list_screen.dart';
import '../../features/orders/presentation/screens/order_history_screen.dart';
import '../../features/checkout/presentation/screens/checkout_screen.dart';
import '../../features/checkout/presentation/screens/order_confirmation_screen.dart';
import '../../features/profile/presentation/screens/change_email_screen.dart';
import '../../features/profile/presentation/screens/change_password_screen.dart';
import '../../features/profile/presentation/screens/favorites_screen.dart';
import '../../features/profile/presentation/screens/addresses_screen.dart';
import '../../features/profile/presentation/screens/add_address_screen.dart';
import '../../features/profile/presentation/screens/saved_cards_screen.dart';
import 'main_scaffold.dart';

class AppRouter {
  // Rota İsimleri
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String productList = '/products';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String categories = '/categories';
  static const String profile = '/profile';
  static const String orderHistory = '/order-history';
  static const String checkout = '/checkout';
  static const String orderConfirmation = '/order-confirmation';
  static const String changeEmail = '/change-email';
  static const String changePassword = '/change-password';
  static const String favorites = '/favorites';
  static const String addresses = '/addresses';
  static const String addAddress = '/add-address';
  static const String savedCards = '/saved-cards';

  // Global navigasyon anahtarı
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: splash, 
    routes: [
      // Splash (Dinamik Oturum Açılış Ekranı)
      GoRoute(
        path: splash,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SplashScreen(),
      ),

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
      
      // Ürün Detay
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

      // BottomNavBar 
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: productList,
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              return ProductListScreen(
                categoryId: extra?['categoryId'] as String?,
                initialSearch: extra?['search'] as String?,
              );
            },
          ),
          GoRoute(
            path: categories,
            builder: (context, state) => const CategoryListScreen(),
          ),
          GoRoute(
            path: cart,
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: checkout,
            builder: (context, state) => const CheckoutScreen(),
          ),
          GoRoute(
            path: orderConfirmation,
            builder: (context, state) => const OrderConfirmationScreen(),
          ),
          GoRoute(
            path: profile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: orderHistory,
            builder: (context, state) => const OrderHistoryScreen(),
          ),
          GoRoute(
            path: changeEmail,
            builder: (context, state) => const ChangeEmailScreen(),
          ),
          GoRoute(
            path: changePassword,
            builder: (context, state) => const ChangePasswordScreen(),
          ),
          GoRoute(
            path: favorites,
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: addresses,
            builder: (context, state) => const AddressesScreen(),
          ),
          GoRoute(
            path: addAddress,
            builder: (context, state) => const AddAddressScreen(),
          ),
          GoRoute(
            path: savedCards,
            builder: (context, state) => const SavedCardsScreen(),
          ),
        ],
      ),
    ],
  );
}