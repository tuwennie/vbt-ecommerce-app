import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
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
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    final authResponse = AuthResponseModel.fromJson(response.data);

    final token = (response.data['access_token'] ?? 
                    response.data['accessToken'] ?? 
                    response.data['token'] ?? 
                    authResponse.accessToken).toString();
    final dynamic rawRefresh = response.data['refresh_token'] ?? 
                              response.data['refreshToken'] ?? 
                              authResponse.refreshToken;
    final String? refreshToken = (rawRefresh != null && rawRefresh.toString() != 'null')
        ? rawRefresh.toString()
        : null;
                    
    // Token'ları güvenli hafızaya kaydet
    await _dioClient.saveTokens(
      accessToken: token,
      refreshToken: refreshToken,
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
      ApiEndpoints.register,
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
      refreshToken: authResponse.refreshToken,
    );
    
    return authResponse;
  }

  @override
  Future<void> logout() async {
    await _dioClient.clearTokens();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final response = await _dioClient.get(ApiEndpoints.me);
    final responseData = response.data is Map<String, dynamic>
        ? (response.data.containsKey('data') ? response.data['data'] : response.data)
        : response.data;
    return UserModel.fromJson(responseData is Map<String, dynamic> ? responseData : {});
  }


  @override
  Future<bool> isLoggedIn() async {
    final token = await _dioClient.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}