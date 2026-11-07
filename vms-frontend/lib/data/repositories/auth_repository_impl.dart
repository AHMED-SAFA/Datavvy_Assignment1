import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/api_constants.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  final SharedPreferences _preferences;

  AuthRepositoryImpl({
    required this._dataSource,
    required this._preferences,
  });

  @override
  Future<String> login(String username, String password) async {
    final response = await _dataSource.login(
      LoginRequestModel(username: username.trim(), password: password),
    );
    await _preferences.setString(ApiConstants.tokenKey, response.token);
    await _preferences.setString(ApiConstants.usernameKey, response.username);
    if (response.expiresIn != null) {
      await _preferences.setInt(
        ApiConstants.tokenExpiryKey,
        DateTime.now()
            .add(Duration(milliseconds: response.expiresIn!))
            .millisecondsSinceEpoch,
      );
    }
    return response.username;
  }

  @override
  Future<void> logout() async {
    await _preferences.remove(ApiConstants.tokenKey);
    await _preferences.remove(ApiConstants.usernameKey);
    await _preferences.remove(ApiConstants.tokenExpiryKey);
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = _preferences.getString(ApiConstants.tokenKey);
    final expiry = _preferences.getInt(ApiConstants.tokenExpiryKey);
    return token != null &&
        token.isNotEmpty &&
        (expiry == null || expiry > DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Future<String?> getCurrentUser() async =>
      _preferences.getString(ApiConstants.usernameKey);

  @override
  Future<String?> getToken() async =>
      _preferences.getString(ApiConstants.tokenKey);
}
