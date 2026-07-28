import 'user_model.dart';

class AuthResponseModel {
  final String accessToken;
  final String? refreshToken;
  final UserModel user;

  AuthResponseModel({
    required this.accessToken,
    this.refreshToken,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;

    return AuthResponseModel(
      accessToken: data['accessToken'] ?? data['access_token'] ?? data['token'] ?? '',
      refreshToken: data['refreshToken'] ?? data['refresh_token'],
      user: UserModel.fromJson(data['user'] ?? {}),
    );
  }
}