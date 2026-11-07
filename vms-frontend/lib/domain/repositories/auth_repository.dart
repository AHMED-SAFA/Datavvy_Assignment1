abstract class AuthRepository {
  Future<String> login(String username, String password);
  Future<void> logout();
  Future<bool> isAuthenticated();
  Future<String?> getCurrentUser();
  Future<String?> getToken();
}
