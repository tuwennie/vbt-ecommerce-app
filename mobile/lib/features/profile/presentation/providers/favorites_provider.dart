import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../products/data/models/product_model.dart';

class FavoritesNotifier extends StateNotifier<List<ProductModel>> {
  FavoritesNotifier() : super([]);

  void toggleFavorite(ProductModel product) {
    if (state.any((p) => p.id == product.id)) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      state = [...state, product];
    }
  }

  bool isFavorite(String productId) {
    return state.any((p) => p.id == productId);
  }

  void removeFavorite(String productId) {
    state = state.where((p) => p.id != productId).toList();
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<ProductModel>>((ref) {
  return FavoritesNotifier();
});
