import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../products/data/models/product_model.dart';

class FavoritesNotifier extends StateNotifier<List<ProductModel>> {
  static const _favoritesKey = 'user_favorites_list';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  FavoritesNotifier() : super([]) {
    _loadFavoritesFromStorage();
  }

  Future<void> _loadFavoritesFromStorage() async {
    try {
      final jsonStr = await _storage.read(key: _favoritesKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final List decoded = jsonDecode(jsonStr);
        state = decoded
            .map((item) => ProductModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
    } catch (_) {}
  }

  Future<void> _saveFavoritesToStorage() async {
    try {
      final jsonStr = jsonEncode(state.map((p) => p.toJson()).toList());
      await _storage.write(key: _favoritesKey, value: jsonStr);
    } catch (_) {}
  }

  void toggleFavorite(ProductModel product) {
    if (state.any((p) => p.id == product.id)) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      state = [...state, product];
    }
    _saveFavoritesToStorage();
  }

  bool isFavorite(String productId) {
    return state.any((p) => p.id == productId);
  }

  void removeFavorite(String productId) {
    state = state.where((p) => p.id != productId).toList();
    _saveFavoritesToStorage();
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<ProductModel>>((ref) {
  return FavoritesNotifier();
});
