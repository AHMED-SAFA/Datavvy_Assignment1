/// Response model for login API call.
class LoginResponseModel {
  final String token;
  final String tokenType;
  final String username;
  final int? expiresIn;

  const LoginResponseModel({
    required this.token,
    required this.tokenType,
    required this.username,
    this.expiresIn,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] as String? ?? '',
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      username: json['username'] as String? ?? '',
      expiresIn: json['expiresIn'] as int?,
    );
  }
}
