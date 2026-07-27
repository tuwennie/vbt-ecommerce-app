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

  final DioClient _dioClient = DioClient();

  CartNotifier(this._cartRepository) : super(CartState()) {
    fetchCart();
  }

  Future<List<dynamic>> _fetchProductsList() async {
    try {
      final response = await _dioClient.get('/products');
      final rawData = response.data;
      if (rawData is Map<String, dynamic>) {
        final items = rawData['data'] ?? rawData['items'] ?? rawData['products'];
        if (items is List) return items;
      } else if (rawData is List) {
        return rawData;
      }
    } catch (_) {}
    return [];
  }

  CartItemModel _sanitizeItem(
    CartItemModel newItem,
    List<CartItemModel> existingItems,
    List<dynamic> dbProducts,
  ) {
    double itemPrice = newItem.price;
    String? itemImage = newItem.imageUrl;

    // 1. Ürün listesinden veritabanındaki gerçek ürünü eşleştir
    final matchedProduct = dbProducts.where((p) {
      if (p is Map<String, dynamic>) {
        return p['id']?.toString() == newItem.productId;
      }
      return false;
    }).firstOrNull;

    if (matchedProduct != null && matchedProduct is Map<String, dynamic>) {
      if (itemPrice <= 0 && matchedProduct['price'] != null) {
        itemPrice = double.tryParse(matchedProduct['price'].toString()) ?? itemPrice;
      }

      final images = matchedProduct['images'] as List?;
      if (images != null && images.isNotEmpty) {
        final primaryImg = images.firstWhere(
          (img) => img is Map && img['isPrimary'] == true,
          orElse: () => images.first,
        );
        if (primaryImg is Map<String, dynamic> && primaryImg['imageUrl'] != null) {
          itemImage = primaryImg['imageUrl'].toString();
        }
      }
    }

    // 2. Eski yerel sepet öğesinden yedekle
    final oldMatch = existingItems.where(
      (o) => o.productId == newItem.productId || o.id == newItem.id,
    ).firstOrNull;

    if (oldMatch != null) {
      if (itemPrice <= 0 && oldMatch.price > 0) {
        itemPrice = oldMatch.price;
      }
      if ((itemImage == null || itemImage.isEmpty) && oldMatch.imageUrl != null && oldMatch.imageUrl!.isNotEmpty) {
        itemImage = oldMatch.imageUrl;
      }
    }

    return CartItemModel(
      id: newItem.id,
      productId: newItem.productId,
      productName: newItem.productName,
      description: newItem.description,
      price: itemPrice,
      quantity: newItem.quantity,
      imageUrl: itemImage,
    );
  }

  // API'den sepet verisini yükle
  Future<void> fetchCart() async {
    state = state.copyWith(isLoading: true);
    try {
      final fetchedCart = await _cartRepository.getCart();
      final oldItems = state.cart?.items ?? [];
      final dbProducts = await _fetchProductsList();

      final sanitizedItems = fetchedCart.items.map((item) {
        return _sanitizeItem(item, oldItems, dbProducts);
      }).toList();

      final sanitizedCart = CartModel(
        items: sanitizedItems,
        totalPrice: sanitizedItems.fold<double>(0, (sum, item) => sum + item.totalPrice),
      );

      if (sanitizedCart.items.isNotEmpty || sanitizedCart.totalPrice > 0) {
        state = state.copyWith(isLoading: false, cart: sanitizedCart);
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
    final dbProducts = await _fetchProductsList();

    String? validImage = imageUrl;
    if (validImage == null || validImage.isEmpty) {
      final matched = dbProducts.where((p) => p is Map && p['id']?.toString() == productId).firstOrNull;
      if (matched is Map<String, dynamic> && matched['images'] is List && (matched['images'] as List).isNotEmpty) {
        validImage = matched['images'][0]['imageUrl']?.toString();
      }
    }

    if (existingIndex >= 0) {
      final currentItem = updatedItems[existingIndex];
      final itemPrice = (currentItem.price > 0) ? currentItem.price : (price ?? 0.0);
      final itemImg = (validImage != null && validImage.isNotEmpty)
          ? validImage
          : currentItem.imageUrl;

      updatedItems[existingIndex] = CartItemModel(
        id: currentItem.id,
        productId: currentItem.productId,
        productName: currentItem.productName,
        price: itemPrice,
        quantity: currentItem.quantity + quantity,
        imageUrl: itemImg,
      );
    } else {
      updatedItems.add(
        CartItemModel(
          id: productId,
          productId: productId,
          productName: productName ?? 'Ürün',
          description: null,
          price: price ?? 0.0,
          quantity: quantity,
          imageUrl: validImage,
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
        final sanitizedItems = updatedCart.items.map((item) {
          return _sanitizeItem(item, optimisticCart.items, dbProducts);
        }).toList();

        final sanitizedCart = CartModel(
          items: sanitizedItems,
          totalPrice: sanitizedItems.fold<double>(0, (sum, item) => sum + item.totalPrice),
        );

        state = state.copyWith(cart: sanitizedCart, errorMessage: null);
      }
    } catch (_) {
      state = state.copyWith(errorMessage: 'Ürün sepete eklenemedi, ancak yerel sepet güncellendi.');
    }
  }

  // Adet Güncelleme
  Future<void> updateQuantity(String productId, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    final currentCart = state.cart ?? CartModel(items: [], totalPrice: 0);
    final updatedItems = currentCart.items.map((item) {
      if (item.productId == productId || item.id == productId) {
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
      final dbProducts = await _fetchProductsList();
      final updatedCart = await _cartRepository.updateQuantity(
        productId: productId,
        quantity: newQuantity,
      );

      final sanitizedItems = updatedCart.items.map((item) {
        return _sanitizeItem(item, optimisticCart.items, dbProducts);
      }).toList();

      final sanitizedCart = CartModel(
        items: sanitizedItems,
        totalPrice: sanitizedItems.fold<double>(0, (sum, item) => sum + item.totalPrice),
      );

      state = state.copyWith(cart: sanitizedCart, errorMessage: null);
    } catch (_) {
      state = state.copyWith(errorMessage: 'Adet güncellenemedi.');
    }
  }

  // Sepetten Ürün Çıkar
  Future<void> removeFromCart(String productId) async {
    final currentCart = state.cart ?? CartModel(items: [], totalPrice: 0);
    final updatedItems = currentCart.items.where((item) => item.productId != productId && item.id != productId).toList();
    final optimisticCart = CartModel(
      items: updatedItems,
      totalPrice: updatedItems.fold<double>(0, (sum, item) => sum + item.totalPrice),
    );

    state = state.copyWith(cart: optimisticCart, errorMessage: null);

    try {
      final dbProducts = await _fetchProductsList();
      final updatedCart = await _cartRepository.removeFromCart(productId: productId);

      final sanitizedItems = updatedCart.items.map((item) {
        return _sanitizeItem(item, optimisticCart.items, dbProducts);
      }).toList();

      final sanitizedCart = CartModel(
        items: sanitizedItems,
        totalPrice: sanitizedItems.fold<double>(0, (sum, item) => sum + item.totalPrice),
      );

      state = state.copyWith(cart: sanitizedCart, errorMessage: null);
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