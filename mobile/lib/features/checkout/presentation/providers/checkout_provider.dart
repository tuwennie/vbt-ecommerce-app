import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../data/models/address_model.dart';
import '../../data/models/create_order_dto.dart';
import '../../domain/repositories/order_repository_impl.dart';
import '../../domain/repositories/order_repository.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(dioClient: DioClient());
});

class CheckoutState {
  final bool isLoading;
  final List<AddressModel> addresses;
  final AddressModel? selectedAddress;
  final bool isOrderSuccess;
  final String? errorMessage;

  CheckoutState({
    this.isLoading = false,
    this.addresses = const [],
    this.selectedAddress,
    this.isOrderSuccess = false,
    this.errorMessage,
  });

  // Form Validation: Kullanıcı adres seçmediyse buton pasif kalacak
  bool get isFormValid => selectedAddress != null;

  CheckoutState copyWith({
    bool? isLoading,
    List<AddressModel>? addresses,
    AddressModel? selectedAddress,
    bool? isOrderSuccess,
    String? errorMessage,
  }) {
    return CheckoutState(
      isLoading: isLoading ?? this.isLoading,
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      isOrderSuccess: isOrderSuccess ?? this.isOrderSuccess,
      errorMessage: errorMessage,
    );
  }
}

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  final OrderRepository _orderRepository;
  final Ref _ref;

  CheckoutNotifier(this._orderRepository, this._ref) : super(CheckoutState()) {
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    state = state.copyWith(isLoading: true);
    try {
      final list = await _orderRepository.getAddresses();
      state = state.copyWith(
        isLoading: false,
        addresses: list,
        selectedAddress: list.isNotEmpty ? list.first : null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Adresler yüklenemedi.');
    }
  }

  void selectAddress(AddressModel address) {
    state = state.copyWith(selectedAddress: address);
  }

Future<OrderResponseModel?> submitOrder({String? note}) async {
    if (!state.isFormValid) return null;

    state = state.copyWith(isLoading: true);
    try {
      final dto = CreateOrderDto(
        addressId: state.selectedAddress!.id,
        note: note,
      );
      
      final orderResponse = await _orderRepository.createOrder(dto);
      if (orderResponse != null) {
        _ref.read(cartProvider.notifier).fetchCart(); // Sepeti sıfırla
        state = state.copyWith(isLoading: false, isOrderSuccess: true);
        return orderResponse;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Sipariş oluşturulamadı.');
    }
    return null;
  }
}

final checkoutProvider = StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return CheckoutNotifier(repository, ref);
});