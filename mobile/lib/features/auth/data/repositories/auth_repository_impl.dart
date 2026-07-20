import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DioClient _dioClient;

  AuthRepositoryImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dioClient.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final authResponse = AuthResponseModel.fromJson(response.data);
    
    // Token'ları güvenli hafızaya kaydet
    await _dioClient.saveTokens(
      accessToken: authResponse.accessToken,
    );
    
    return authResponse;
  }

  @override
  Future<AuthResponseModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final response = await _dioClient.post(
      '/auth/register',
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      },
    );

    final authResponse = AuthResponseModel.fromJson(response.data);
    
    // Token'ları güvenli hafızaya kaydet
    await _dioClient.saveTokens(
      accessToken: authResponse.accessToken,
    );
    
    return authResponse;
  }

  @override
  Future<void> logout() async {
    await _dioClient.clearTokens();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final response = await _dioClient.get('/auth/me');
    final data = response.data.containsKey('data') ? response.data['data'] : response.data;
    return UserModel.fromJson(data);
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _dioClient.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}