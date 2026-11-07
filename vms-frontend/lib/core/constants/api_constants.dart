class ApiConstants {
  // Base URL pointing to the Spring Boot backend
  static const String baseUrl = 'http://localhost:8081/api';

  // Timeout Configurations
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Auth Endpoints
  static const String loginEndpoint = '/auth/login';

  // Vehicle Endpoints
  static const String vehiclesEndpoint = '/vehicles';
  static const String searchVehiclesEndpoint = '/vehicles/search';

  // Storage Keys
  static const String tokenKey = 'vms_jwt_token';
  static const String usernameKey = 'vms_username';
  static const String tokenExpiryKey = 'vms_token_expiry';

  static const String login = loginEndpoint;
  static const String vehicles = vehiclesEndpoint;
  static const String vehicleSearch = searchVehiclesEndpoint;

  static String vehicleById(int id) => '$vehiclesEndpoint/$id';
}
