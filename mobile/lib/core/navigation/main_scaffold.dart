import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/navigation/app_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRouter.categories)) return 1;
    if (location.startsWith(AppRouter.cart)) return 2;
    if (location.startsWith(AppRouter.profile)) return 3;
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
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      // Alt boşluğu sıfırlayıp bar'ı sayfanın alt tarafında süzülen bir kart gibi konumlandırıyoruz
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 8),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(36), // Tam oval kapsül görünümü
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: const Color(0xFFF3F4F6),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                index: 0,
                selectedIndex: selectedIndex,
                icon: Icons.home_rounded,
                unselectedIcon: Icons.home_outlined,
              ),
              _buildNavItem(
                context,
                index: 1,
                selectedIndex: selectedIndex,
                icon: Icons.menu_rounded, // Tasarımdaki 3 çizgili ikon
                unselectedIcon: Icons.menu_rounded,
              ),
              _buildNavItem(
                context,
                index: 2,
                selectedIndex: selectedIndex,
                icon: Icons.shopping_cart_rounded,
                unselectedIcon: Icons.shopping_cart_outlined,
              ),
              _buildNavItem(
                context,
                index: 3,
                selectedIndex: selectedIndex,
                icon: Icons.person_rounded,
                unselectedIcon: Icons.person_outline_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required int selectedIndex,
    required IconData icon,
    required IconData unselectedIcon,
  }) {
    final isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () => _onItemTapped(index, context),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent, // Seçilince Parlak Mavi Yuvarlak
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Icon(
          isSelected ? icon : unselectedIcon,
          color: isSelected ? Colors.white : const Color(0xFF4B5563),
          size: 26,
        ),
      ),
    );
  }
}