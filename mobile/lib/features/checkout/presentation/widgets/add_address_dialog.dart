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
                validator: (val) => val == null || val.isEmpty ? 'Başlık giriniz' : null,
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'Şehir'),
                validator: (val) => val == null || val.isEmpty ? 'Şehir giriniz' : null,
              ),
              TextFormField(
                controller: _districtController,
                decoration: const InputDecoration(labelText: 'İlçe'),
                validator: (val) => val == null || val.isEmpty ? 'İlçe giriniz' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Açık Adres'),
                maxLines: 2,
                validator: (val) => val == null || val.isEmpty ? 'Açık adres giriniz' : null,
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
                title: _titleController.text,
                fullAddress: _addressController.text,
                city: _cityController.text,
                district: _districtController.text,
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