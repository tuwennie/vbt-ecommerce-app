import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import 'app_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Mevcut rotaya göre hangi sekmenin aktif olduğunu hesaplayalım
    final String location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location.startsWith(AppRouter.cart)) currentIndex = 1;
    if (location.startsWith(AppRouter.favorites)) currentIndex = 2;
    if (location.startsWith(AppRouter.profile)) currentIndex = 3;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.brandBlue, // Aktif sekme Tuba'nın marka mavisi
          unselectedItemColor: AppColors.textSecondary, // Pasif sekmeler gri
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          onTap: (index) {
            switch (index) {
              case 0:
                context.go(AppRouter.productList);
                break;
              case 1:
                context.go(AppRouter.cart);
                break;
              case 2:
                context.go(AppRouter.favorites);
                break;
              case 3:
                context.go(AppRouter.profile);
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Keşfet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Sepetim',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Favorilerim',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profilim',
            ),
          ],
        ),
      ),
    );
  }
}