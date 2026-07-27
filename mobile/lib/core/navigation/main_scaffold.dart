import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/navigation/app_router.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';

class MainScaffold extends ConsumerWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRouter.categories)) return 1;
    if (location.startsWith(AppRouter.cart) || location.startsWith(AppRouter.checkout)) return 2;
    if (location.startsWith(AppRouter.profile) ||
        location.startsWith(AppRouter.changeEmail) ||
        location.startsWith(AppRouter.changePassword) ||
        location.startsWith(AppRouter.orderHistory) ||
        location.startsWith(AppRouter.orderConfirmation) ||
        location.startsWith(AppRouter.favorites) ||
        location.startsWith(AppRouter.addresses) ||
        location.startsWith(AppRouter.addAddress) ||
        location.startsWith(AppRouter.savedCards)) {
      return 3;
    }
    return 0; // Default: Home / ProductList
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRouter.productList);
        break;
      case 1:
        context.go(AppRouter.categories);
        break;
      case 2:
        context.go(AppRouter.cart);
        break;
      case 3:
        context.go(AppRouter.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = _calculateSelectedIndex(context);
    
    // Sepetteki toplam ürün sayısını canlı okuma
    final cartState = ref.watch(cartProvider);
    final itemCount = cartState.cart?.items.fold<int>(
          0,
          (sum, item) => sum + item.quantity,
        ) ?? 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              index: 0,
              selectedIndex: selectedIndex,
              label: 'Home',
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_rounded,
            ),
            _buildNavItem(
              context,
              index: 1,
              selectedIndex: selectedIndex,
              label: 'Categories',
              icon: Icons.menu_rounded, // Hamburger menü ikonu korundu
              selectedIcon: Icons.menu_rounded,
            ),
            _buildNavItem(
              context,
              index: 2,
              selectedIndex: selectedIndex,
              label: 'Cart',
              icon: Icons.shopping_cart_outlined,
              selectedIcon: Icons.shopping_cart_rounded,
              badgeCount: itemCount,
            ),
            _buildNavItem(
              context,
              index: 3,
              selectedIndex: selectedIndex,
              label: 'Profile',
              icon: Icons.person_outline_rounded,
              selectedIcon: Icons.person_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required int selectedIndex,
    required String label,
    required IconData icon,
    required IconData selectedIcon,
    int badgeCount = 0,
  }) {
    final isSelected = index == selectedIndex;
    const activeColor = Color(0xFF1D61E7); // Tasarımdaki canlı mavi
    const inactiveColor = Color(0xFF4B5563);

    return InkWell(
      onTap: () => _onItemTapped(index, context),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? activeColor : inactiveColor,
                size: 26,
              ),
              if (badgeCount > 0)
                Positioned(
                  right: -8,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFDC2626), // Kırmızı rozet
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}