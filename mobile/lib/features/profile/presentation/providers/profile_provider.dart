import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../data/models/user_profile_model.dart';

class ProfileState {
  final bool isLoading;
  final UserProfileModel? user;
  final String? errorMessage;

  ProfileState({this.isLoading = false, this.user, this.errorMessage});

  ProfileState copyWith({
    bool? isLoading,
    UserProfileModel? user,
    String? errorMessage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final DioClient _dioClient;

  ProfileNotifier(this._dioClient) : super(ProfileState()) {
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // 1. Endpoint çağrısı
      final response = await _dioClient.get(ApiEndpoints.me);

      // Backend response interceptor'ı her zaman { success, data } sarması döndürür.
      // Bazı durumlarda response.data doğrudan bir Map olabilir; bunu güvenli şekilde işliyoruz.
      final responseData = response.data is Map<String, dynamic>
          ? (response.data.containsKey('data') ? response.data['data'] : response.data)
          : response.data;

      final profile = UserProfileModel.fromJson(
        responseData is Map<String, dynamic>
            ? responseData
            : <String, dynamic>{},
      );
      state = state.copyWith(isLoading: false, user: profile);
    } on CustomApiException catch (e) {
      // DioClient'ın yakaladığı gerçek hata mesajını (örneğin 401 Unauthorized) state'e aktarıyoruz
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    } catch (e) {
      // Genel beklenmeyen hatalar için detaylı mesaj
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Profil bilgileri yüklenemedi: $e',
      );
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(DioClient());
});