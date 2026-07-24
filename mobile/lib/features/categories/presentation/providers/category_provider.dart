import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../products/data/models/product_model.dart'; 

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(DioClient());
});

abstract class CategoryRepository {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRepositoryImpl implements CategoryRepository {
  final DioClient _dioClient;
  CategoryRepositoryImpl(this._dioClient);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _dioClient.get(ApiEndpoints.categories);
    final List data = response.data is List ? response.data : (response.data['data'] ?? []);
    return data.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}

class CategoryListNotifier extends AsyncNotifier<List<CategoryModel>> {
  @override
  FutureOr<List<CategoryModel>> build() async {
    final repository = ref.read(categoryRepositoryProvider);
    return await repository.getCategories();
  }
}

final categoryListProvider = AsyncNotifierProvider<CategoryListNotifier, List<CategoryModel>>(() {
  return CategoryListNotifier();
});