import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/app_router.dart';
import '../providers/profile_provider.dart';

class ChangeEmailScreen extends ConsumerStatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  ConsumerState<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends ConsumerState<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newEmailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  bool _isConfirmObscured = true;

  @override
  void dispose() {
    _newEmailController.dispose();
    _confirmEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final currentEmail = profileState.user?.email ?? 'alex.johnson@example.com';

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRouter.profile);
            }
          },
        ),
        title: const Text(
          'E-Posta Değişikliği',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Açıklama Metni
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'E-posta adresinizi güncellemek için lütfen yeni e-postanızı girin ve mevcut şifrenizle onaylayın.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // 1. Mevcut E-posta (Pasif)
                const Text(
                  'Mevcut E-posta',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.mail_outline, color: Color(0xFF6B7280), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          currentEmail,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF374151),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Yeni E-posta
                const Text(
                  'Yeni E-posta',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _newEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Yeni e-posta adresinizi girin',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    prefixIcon: const Icon(Icons.mail_outline, color: Color(0xFF6B7280), size: 20),
                    filled: true,
                    fillColor: const Color(0xFFE5E7EB).withValues(alpha: 0.5),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Yeni e-posta adresinizi giriniz';
                    }
                    if (!val.contains('@') || !val.contains('.')) {
                      return 'Geçerli bir e-posta adresi giriniz';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // 3. Yeni E-Posta (Tekrar)
                const Text(
                  'Yeni E-Posta (Tekrar)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmEmailController,
                  obscureText: _isConfirmObscured,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Yeni e-posta adresinizi girin',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    prefixIcon: const Icon(Icons.mail_outline, color: Color(0xFF6B7280), size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: const Color(0xFF6B7280),
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmObscured = !_isConfirmObscured;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: const Color(0xFFE5E7EB).withValues(alpha: 0.5),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Lütfen e-posta adresinizi tekrar giriniz';
                    }
                    if (val.trim() != _newEmailController.text.trim()) {
                      return 'E-posta adresleri eşleşmiyor';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Aksiyon Butonu (E-postayı Güncelle ->)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('E-posta adresiniz başarıyla güncellendi.'),
                            backgroundColor: Color(0xFF16A34A),
                          ),
                        );
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRouter.profile);
                        }
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'E-postayı Güncelle',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
