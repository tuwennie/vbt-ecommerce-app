import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/components/custom_button.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // TODO: Haftaya Kübra'nın API katmanı bağlandığında burası güncellenecek.
      // Şimdilik akıcı geçiş (DoD) için mock bir gecikme ekliyoruz.
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        setState(() => _isLoading = false);
        
        // Kayıt başarılı olduktan sonra kullanıcıyı doğrudan ana sayfaya (Ürün listesine) alıyoruz
        context.go(AppRouter.productList);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hesabınız başarıyla oluşturuldu!')),
        );
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
              const SizedBox(height: 30),
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
              const SizedBox(height: 24),

              // 2. Kayıt Kartı (White Surface Card)
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
                        'Kayıt Ol',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Hesabınızı oluşturarak alışverişe hemen başlayın.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Ad Soyad Alanı
                      CustomTextField(
                        controller: _nameController,
                        labelText: 'Ad Soyad',
                        hintText: 'John Doe',
                        prefixIcon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ad soyad alanı boş bırakılamaz';
                          }
                          if (value.trim().split(' ').length < 2) {
                            return 'Lütfen adınızı ve soyadınızı tam giriniz';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // E-posta Alanı
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'E-posta Adresi',
                        hintText: 'ornek@eposta.com',
                        prefixIcon: Icons.mail_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'E-posta alanı boş bırakılamaz';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Geçerli bir e-posta adresi giriniz';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Şifre Alanı
                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'Şifre',
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

                      // Kayıt Ol Butonu
                      CustomButton(
                        text: 'Kayıt Ol',
                        isLoading: _isLoading,
                        showArrow: true,
                        onPressed: _handleRegister,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Alt Yönlendirme Alanı
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Zaten bir hesabınız var mı? ',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => context.pop(), // Rota yığınından çıkarıp login'e geri döner
                    child: const Text(
                      'Giriş Yap',
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