import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/address_model.dart';
import '../providers/checkout_provider.dart';

class AddAddressDialog extends ConsumerStatefulWidget {
  const AddAddressDialog({super.key});

  @override
  ConsumerState<AddAddressDialog> createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends ConsumerState<AddAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _phoneController = TextEditingController(text: '05555555555');
  final _postalCodeController = TextEditingController(text: '34000');

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _phoneController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: const Text('Yeni Adres Ekle'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Adres Başlığı (Ev, İş)'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Başlık giriniz' : null,
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'Şehir'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Şehir giriniz' : null,
              ),
              TextFormField(
                controller: _districtController,
                decoration: const InputDecoration(labelText: 'İlçe'),
                validator: (val) => val == null || val.trim().isEmpty ? 'İlçe giriniz' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Açık Adres'),
                maxLines: 2,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Açık adres giriniz';
                  if (val.trim().length < 10) return 'Açık adres en az 10 karakter olmalıdır';
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Telefon Numarası'),
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Telefon giriniz';
                  final digits = val.replaceAll(RegExp(r'[^0-9]'), '');
                  if (digits.length < 10) return 'Geçerli bir telefon numarası giriniz';
                  return null;
                },
              ),
              TextFormField(
                controller: _postalCodeController,
                decoration: const InputDecoration(labelText: 'Posta Kodu'),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Posta kodu giriniz';
                  if (!RegExp(r'^[0-9]{5}$').hasMatch(val.trim())) return 'Posta kodu 5 haneli olmalıdır';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final newAddress = AddressModel(
                id: '',
                title: _titleController.text.trim(),
                fullAddress: _addressController.text.trim(),
                city: _cityController.text.trim(),
                district: _districtController.text.trim(),
                phone: _phoneController.text.trim(),
                postalCode: _postalCodeController.text.trim(),
              );

              final navigator = Navigator.of(context);
              // Backend'e yeni adresi kaydet ve listeyi yenile
              await ref.read(orderRepositoryProvider).addAddress(newAddress);
              await ref.read(checkoutProvider.notifier).fetchAddresses();
              
              if (mounted) navigator.pop();
            }
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}