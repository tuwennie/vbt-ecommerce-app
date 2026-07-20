import 'user_model.dart';

class AuthResponseModel {
  final String accessToken;
  final UserModel user;

  AuthResponseModel({
    required this.accessToken,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;

    return AuthResponseModel(
      accessToken: data['accessToken'] ?? data['access_token'] ?? data['token'] ?? '',
      user: UserModel.fromJson(data['user'] ?? {}),
    );
  }
}