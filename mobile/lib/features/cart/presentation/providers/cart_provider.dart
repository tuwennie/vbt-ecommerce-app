import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/models/cart_item_model.dart';
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
      if (cart.items.isNotEmpty || cart.totalPrice > 0) {
        state = state.copyWith(isLoading: false, cart: cart);
      } else {
        state = state.copyWith(isLoading: false, cart: state.cart ?? CartModel(items: [], totalPrice: 0));
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Sepet yüklenemedi.');
    }
  }

  // Sepete Ürün Ekle
  Future<void> addToCart(
    String productId, {
    int quantity = 1,
    String? productName,
    double? price,
    String? imageUrl,
  }) async {
    final currentCart = state.cart ?? CartModel(items: [], totalPrice: 0);
    final existingIndex = currentCart.items.indexWhere((item) => item.productId == productId);
    final updatedItems = List<CartItemModel>.from(currentCart.items);

    if (existingIndex >= 0) {
      final currentItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = CartItemModel(
        id: currentItem.id,
        productId: currentItem.productId,
        productName: currentItem.productName,
        price: currentItem.price,
        quantity: currentItem.quantity + quantity,
        imageUrl: currentItem.imageUrl,
      );
    } else {
      updatedItems.add(
        CartItemModel(
          id: productId,
          productId: productId,
          productName: productName ?? 'Ürün',
          description: null,
          price: price ?? 0,
          quantity: quantity,
          imageUrl: imageUrl,
        ),
      );
    }

    final optimisticCart = CartModel(
      items: updatedItems,
      totalPrice: updatedItems.fold<double>(0, (sum, item) => sum + item.totalPrice),
    );

    state = state.copyWith(cart: optimisticCart, errorMessage: null);

    try {
      final updatedCart = await _cartRepository.addToCart(productId: productId, quantity: quantity);
      if (updatedCart.items.isNotEmpty || updatedCart.totalPrice > 0) {
        state = state.copyWith(cart: updatedCart, errorMessage: null);
      }
    } catch (_) {
      state = state.copyWith(errorMessage: 'Ürün sepete eklenemedi, ancak yerel sepet güncellendi.');
    }
  }

  // Adet Güncelleme (Eklendi ➕)
  Future<void> updateQuantity(String productId, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeFromCart(productId);
      return;
    }
      
    final currentCart = state.cart ?? CartModel(items: [], totalPrice: 0);
    final updatedItems = currentCart.items.map((item) {
      if (item.productId == productId) {
        return CartItemModel(
          id: item.id,
          productId: item.productId,
          productName: item.productName,
          price: item.price,
          description: item.description,
          quantity: newQuantity,
          imageUrl: item.imageUrl,
        );
      }
      return item;
    }).toList();

    final optimisticCart = CartModel(
      items: updatedItems,
      totalPrice: updatedItems.fold<double>(0, (sum, item) => sum + item.totalPrice),
    );

    state = state.copyWith(cart: optimisticCart, errorMessage: null);

    try {
      final updatedCart = await _cartRepository.updateQuantity(
        productId: productId,
        quantity: newQuantity,
      );
      state = state.copyWith(cart: updatedCart, errorMessage: null);
    } catch (_) {
      state = state.copyWith(errorMessage: 'Adet güncellenemedi.');
    }
  }

  // Sepetten Ürün Çıkar
  Future<void> removeFromCart(String productId) async {
    final currentCart = state.cart ?? CartModel(items: [], totalPrice: 0);
    final updatedItems = currentCart.items.where((item) => item.productId != productId).toList();
    final optimisticCart = CartModel(
      items: updatedItems,
      totalPrice: updatedItems.fold<double>(0, (sum, item) => sum + item.totalPrice),
    );

    state = state.copyWith(cart: optimisticCart, errorMessage: null);

    try {
      final updatedCart = await _cartRepository.removeFromCart(productId: productId);
      state = state.copyWith(cart: updatedCart, errorMessage: null);
    } catch (_) {
      state = state.copyWith(errorMessage: 'Ürün sepetten silinemedi.');
    }
  }

  // Sepeti Sıfırla (Eklendi 🧹)
  void clearCart() {
    state = CartState(cart: CartModel(items: [], totalPrice: 0));
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return CartNotifier(repository);
});