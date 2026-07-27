import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../orders/presentation/providers/order_provider.dart';
import '../../data/models/address_model.dart';
import '../../data/models/create_order_dto.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/repositories/order_repository_impl.dart';


// 1. OrderRepository Provider Tanımı
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(dioClient: DioClient());
});

// Checkout State Yapısı
class CheckoutState {
  final bool isLoading;
  final String? errorMessage;
  final OrderResponseModel? completedOrder;
  final List<AddressModel> userAddresses;
  final AddressModel? selectedAddress;

  CheckoutState({
    this.isLoading = false,
    this.errorMessage,
    this.completedOrder,
    this.userAddresses = const [],
    this.selectedAddress,
  });

  CheckoutState copyWith({
    bool? isLoading,
    String? errorMessage,
    OrderResponseModel? completedOrder,
    List<AddressModel>? userAddresses,
    AddressModel? selectedAddress,
  }) {
    return CheckoutState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      completedOrder: completedOrder ?? this.completedOrder,
      userAddresses: userAddresses ?? this.userAddresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
    );
  }
}

// Checkout Notifier
class CheckoutNotifier extends StateNotifier<CheckoutState> {
  final OrderRepository _orderRepository;
  final Ref _ref;

  CheckoutNotifier(this._orderRepository, this._ref) : super(CheckoutState());

  void setSelectedAddress(AddressModel address) {
    state = state.copyWith(selectedAddress: address);
  }

  // 2. Eksik olan fetchAddresses Metodunun Repository Entegrasyonu
  Future<void> fetchAddresses() async {
    try {
      final addresses = await _orderRepository.getAddresses();
      final currentSelected = state.selectedAddress;
      AddressModel? newSelected;
      if (currentSelected != null && addresses.any((a) => a.id == currentSelected.id)) {
        newSelected = addresses.firstWhere((a) => a.id == currentSelected.id);
      } else if (addresses.isNotEmpty) {
        newSelected = addresses.first;
      }
      state = state.copyWith(
        userAddresses: addresses,
        selectedAddress: newSelected,
      );
    } catch (_) {
      // Adresler çekilemezse varsayılan liste boş kalabilir
    }
  }

  // Sipariş Oluşturma Fonksiyonu
  Future<bool> createOrder({
    required String address,
    required String city,
    required String zipCode,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // 1. Adres kontrolü: Seçili adres yoksa adresleri yükle veya yeni adres oluştur
      String targetAddressId = state.selectedAddress?.id ?? '';

      if (targetAddressId.isEmpty) {
        await fetchAddresses();
        targetAddressId = state.selectedAddress?.id ?? '';
      }

      if (targetAddressId.isEmpty && state.userAddresses.isNotEmpty) {
        targetAddressId = state.userAddresses.first.id;
      }

      // Hala adres yoksa girilen verilerle otomatik adres oluştur
      if (targetAddressId.isEmpty) {
        final newAddress = AddressModel(
          id: '',
          title: 'Teslimat Adresi',
          recipientName: 'Müşteri Adı',
          phone: '05555555555',
          city: city.trim().isNotEmpty ? city.trim() : 'İstanbul',
          district: 'Merkez',
          fullAddress: address.trim(),
          postalCode: zipCode.trim().isNotEmpty ? zipCode.trim() : '34000',
        );
        final created = await _orderRepository.addAddress(newAddress);
        targetAddressId = created.id;
      }

      final fullNote = '$address, $city, PK: $zipCode (Mobil uygulama)';
      final dto = CreateOrderDto(
        addressId: targetAddressId,
        paymentMethod: 'CREDIT_CARD',
        note: fullNote,
      );

      final orderResponse = await _orderRepository.createOrder(dto);

      if (orderResponse != null) {
        state = state.copyWith(
          isLoading: false,
          completedOrder: orderResponse,
        );

        // Sepet state'ini ve sipariş geçmişini yenile
        Future.microtask(() {
          _ref.read(cartProvider.notifier).clearCart();
          _ref.invalidate(cartProvider);
          _ref.invalidate(orderProvider);
        });

        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Sipariş oluşturulamadı. Lütfen adres bilgilerinizi kontrol ediniz.',
        );
        return false;
      }
    } on DioException catch (e) {
      final serverData = e.response?.data;
      String message = 'Sipariş oluşturulamadı.';

      if (serverData is Map<String, dynamic>) {
        final msg = serverData['message'];
        if (msg is List) {
          message = msg.join('\n');
        } else if (msg is String) {
          message = msg;
        } else if (serverData['error'] is String) {
          message = serverData['error'];
        }
      }

      state = state.copyWith(isLoading: false, errorMessage: message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Beklenmeyen bir hata oluştu.',
      );
      return false;
    }
  }
}

// Checkout Main Provider
final checkoutProvider = StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return CheckoutNotifier(repository, ref);
});