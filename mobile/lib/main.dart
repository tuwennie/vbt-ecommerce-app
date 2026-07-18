import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_colors.dart';

void main() {
  // State management (Riverpod) için ProviderScope ile sarmalıyoruz
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ShopSwift',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      // Uygulama artık yönlendirmeleri merkezden app_router aracılığıyla alıyor
      routerConfig: AppRouter.router,
    );
  }
}
