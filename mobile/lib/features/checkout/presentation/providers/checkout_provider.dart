import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
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

  // 2. Eksik olan fetchAddresses Metodunun Repository Entegrasyonu
  Future<void> fetchAddresses() async {
    try {
      final addresses = await _orderRepository.getAddresses();
      state = state.copyWith(
        userAddresses: addresses,
        selectedAddress: addresses.isNotEmpty ? addresses.first : null,
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
      // 1. Modelle tam uyumlu DTO oluşturma:
      // addressId bilgisini seçili adresten alıyoruz
      final dto = CreateOrderDto(
        addressId: state.selectedAddress?.id ?? '',
        note: 'Mobil uygulamadan oluşturuldu', // İsteğe bağlı note alanı
      );

      final orderResponse = await _orderRepository.createOrder(dto);

      if (orderResponse != null) {
        state = state.copyWith(
          isLoading: false,
          completedOrder: orderResponse, // toJson() metoduna gerek yok, nesneyi doğrudan atıyoruz
        );

        // Sepet state'ini sıfırla
        _ref.read(cartProvider.notifier).clearCart();
        _ref.invalidate(cartProvider);

        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Sipariş tamamlanamadı.',
        );
        return false;
      }
    } on DioException catch (e) {
      final serverMessage = e.response?.data is Map<String, dynamic>
          ? e.response?.data['message']
          : null;

      final message = serverMessage is List
          ? serverMessage.join(', ')
          : serverMessage?.toString() ?? 'Sipariş oluşturulamadı.';

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