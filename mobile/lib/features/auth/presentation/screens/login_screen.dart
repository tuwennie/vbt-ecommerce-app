import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/components/custom_button.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // TODO: Haftaya Kübra'nın API katmanı bağlandığında burası güncellenecek.
      // Şimdilik akıcı geçiş (DoD) için mock bir gecikme ekliyoruz.
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        setState(() => _isLoading = false);
        // Başarılı giriş sonrası ana sayfaya (Ürün listesine) yönlendiriyoruz
        context.go(AppRouter.productList);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // 1. Logo ve Marka Alanı
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  size: 40,
                  color: AppColors.brandBlue,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'ShopSwift',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 32),

              // 2. Giriş Kartı (White Surface Card)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Giriş Yap',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Hızlı ve güvenli alışveriş için hesabınıza erişin.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // E-posta Alanı
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'E-posta Adresi',
                        hintText: 'ornek@eposta.com',
                        prefixIcon: Icons.mail_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'E-posta alanı boş bırakılamır';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Geçerli bir e-posta adresi giriniz';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Şifre Üstü Link Grubu (Label + Şifremi Unuttum)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Şifre',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Şifre sıfırlama bağlantısı gönderildi.')),
                              );
                            },
                            child: const Text(
                              'Şifremi Unuttum',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.brandBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      
                      // Şifre Alanı
                      CustomTextField(
                        controller: _passwordController,
                        labelText: '', // Yukarıda custom row kullandığımız için boş bırakıyoruz
                        hintText: '••••••••',
                        isPassword: true,
                        prefixIcon: Icons.lock_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Şifre alanı boş bırakılamaz';
                          }
                          if (value.length < 6) {
                            return 'Şifre en az 6 karakter olmalıdır';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Giriş Butonu
                      CustomButton(
                        text: 'Giriş Yap',
                        isLoading: _isLoading,
                        showArrow: true,
                        onPressed: _handleLogin,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 3. Alt Yönlendirme Alanı
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Henüz hesabınız yok mu? ',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => context.push(AppRouter.register),
                    child: const Text(
                      'Kaydol',
                      style: TextStyle(
                        color: AppColors.brandBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}