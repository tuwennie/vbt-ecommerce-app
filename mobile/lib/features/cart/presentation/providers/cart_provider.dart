import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/models/cart_model.dart';
import '../../domain/repositories/cart_repository_impl.dart';
import '../../domain/repositories/cart_repository.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl(dioClient: DioClient());
});

class CartState {
  final bool isLoading;
  final CartModel? cart;
  final String? errorMessage;

  CartState({this.isLoading = false, this.cart, this.errorMessage});

  CartState copyWith({bool? isLoading, CartModel? cart, String? errorMessage}) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      cart: cart ?? this.cart,
      errorMessage: errorMessage,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final CartRepository _cartRepository;

  CartNotifier(this._cartRepository) : super(CartState()) {
    fetchCart();
  }

  // API'den sepet verisini yükle
  Future<void> fetchCart() async {
    state = state.copyWith(isLoading: true);
    try {
      final cart = await _cartRepository.getCart();
      state = state.copyWith(isLoading: false, cart: cart);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Sepet yüklenemedi.');
    }
  }

  // Sepete Ürün Ekle
  Future<void> addToCart(String productId, {int quantity = 1}) async {
    try {
      final updatedCart = await _cartRepository.addToCart(productId: productId, quantity: quantity);
      state = state.copyWith(cart: updatedCart);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Ürün sepete eklenemedi.');
    }
  }

  // Sepetten Ürün Çıkar
  Future<void> removeFromCart(String productId) async {
    try {
      final updatedCart = await _cartRepository.removeFromCart(productId: productId);
      state = state.copyWith(cart: updatedCart);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Ürün sepetten silinemedi.');
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return CartNotifier(repository);
});