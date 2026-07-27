import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/network/dio_client.dart';
import '../../../checkout/presentation/providers/checkout_provider.dart';
import '../../../checkout/data/models/address_model.dart';
import '../providers/profile_provider.dart';

class AddressesScreen extends ConsumerStatefulWidget {
  const AddressesScreen({super.key});

  @override
  ConsumerState<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends ConsumerState<AddressesScreen> {
  late Future<List<AddressModel>> _addressesFuture;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  void _loadAddresses() {
    _addressesFuture = ref.read(orderRepositoryProvider).getAddresses();
  }

  Future<void> _deleteAddress(String addressId) async {
    try {
      if (addressId.isNotEmpty && !addressId.startsWith('profile-')) {
        await DioClient().delete('/addresses/$addressId');
      }
      if (mounted) {
        setState(() {
          _loadAddresses();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Adres başarıyla silindi.'),
            backgroundColor: Color(0xFF16A34A),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Adres silinirken hata oluştu: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final user = profileState.user;

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
          'Adreslerim',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.shade200,
            height: 1.0,
          ),
        ),
      ),
      body: FutureBuilder<List<AddressModel>>(
        future: _addressesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final dbAddresses = snapshot.data ?? [];
          final List<AddressUiModel> itemsToDisplay = [];

          if (dbAddresses.isNotEmpty) {
            for (int i = 0; i < dbAddresses.length; i++) {
              final addr = dbAddresses[i];
              final title = (addr.title != null && addr.title!.isNotEmpty)
                  ? addr.title!
                  : (i == 0 ? 'Ev Adresi' : 'İş Adresi');
              final fullName = (addr.recipientName != null && addr.recipientName!.isNotEmpty)
                  ? addr.recipientName!
                  : (user?.name.isNotEmpty == true ? user!.name : 'Kullanıcı');
              final phone = (addr.phone != null && addr.phone!.isNotEmpty)
                  ? addr.phone!
                  : (user?.phoneNumber ?? '+90 (5xx) xxx-xxxx');

              itemsToDisplay.add(
                AddressUiModel(
                  id: addr.id,
                  title: title,
                  fullName: fullName,
                  fullAddress: addr.fullAddress,
                  district: addr.district,
                  city: addr.city,
                  postalCode: '34000',
                  country: 'Türkiye',
                  phone: phone,
                  isDefault: i == 0,
                  icon: title.toLowerCase().contains('iş')
                      ? Icons.work_outline
                      : Icons.home,
                ),
              );
            }
          } else if (user?.address != null && user!.address!.isNotEmpty) {
            itemsToDisplay.add(
              AddressUiModel(
                id: 'profile-main',
                title: 'Teslimat Adresi',
                fullName: user.name,
                fullAddress: user.address!,
                district: 'Merkez',
                city: 'Türkiye',
                postalCode: '34000',
                country: 'Türkiye',
                phone: user.phoneNumber ?? '+90 (5xx) xxx-xxxx',
                isDefault: true,
                icon: Icons.home,
              ),
            );
          }

          if (itemsToDisplay.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _loadAddresses();
                });
              },
              child: Stack(
                children: [
                  ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF3F4F6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.location_off_outlined,
                                    size: 56,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Kayıtlı Adresiniz Bulunmamaktadır',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Siparişlerinizin teslimatı için kolayca yeni bir adres ekleyebilirsiniz.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6B7280),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: _buildAddAddressButton(context),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _loadAddresses();
              });
            },
            child: Stack(
              children: [
                ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  children: [
                    Text(
                      'Daha hızlı bir ödeme deneyimi için teslimat adreslerinizi yönetin.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (int i = 0; i < itemsToDisplay.length; i++) ...[
                      _buildAddressCard(context, ref, itemsToDisplay[i]),
                      if (i < itemsToDisplay.length - 1) const SizedBox(height: 16),
                    ],
                    const SizedBox(height: 80),
                  ],
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: _buildAddAddressButton(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddAddressButton(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF16A34A),
        foregroundColor: Colors.white,
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () async {
        await context.push(AppRouter.addAddress);
        if (mounted) {
          setState(() {
            _loadAddresses();
          });
        }
      },
      icon: const Icon(Icons.add, color: Colors.white, size: 20),
      label: const Text(
        'YENİ ADRES EKLE',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, WidgetRef ref, AddressUiModel item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: item.isDefault
                          ? const Color(0xFF2563EB)
                          : const Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.icon,
                      color: item.isDefault ? Colors.white : const Color(0xFF4B5563),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  if (item.isDefault) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'VARSAYILAN',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Color(0xFF4B5563), size: 20),
                    onPressed: () {
                      _deleteAddress(item.id);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.fullName,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.fullAddress,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          if (item.district.isNotEmpty || item.city.isNotEmpty)
            Text(
              '${item.district}${item.district.isNotEmpty && item.city.isNotEmpty ? ', ' : ''}${item.city}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          Text(
            item.country,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.phone_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                item.phone,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddressUiModel {
  final String id;
  final String title;
  final String fullName;
  final String fullAddress;
  final String district;
  final String city;
  final String postalCode;
  final String country;
  final String phone;
  final bool isDefault;
  final IconData icon;

  AddressUiModel({
    required this.id,
    required this.title,
    required this.fullName,
    required this.fullAddress,
    required this.district,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.phone,
    required this.isDefault,
    required this.icon,
  });
}
