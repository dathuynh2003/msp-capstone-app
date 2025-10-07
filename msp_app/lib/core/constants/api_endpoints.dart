class ApiEndpoints {
  // Auth endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String register = '/auth/register';
  
  // User endpoints
  static const String users = '/users';
  static const String userProfile = '/users/profile';
  static const String updateProfile = '/users/profile';
  
  // Company endpoints
  static const String companies = '/companies';
  static const String companyById = '/companies/{id}';
  
  // Plan endpoints
  static const String plans = '/plans';
  static const String planById = '/plans/{id}';
  
  // Revenue endpoints
  static const String revenue = '/revenue';
  static const String revenueOverview = '/revenue/overview';
  static const String revenueMetrics = '/revenue/metrics';
  
  // Helper method to replace path parameters
  static String replacePathParams(String endpoint, Map<String, String> params) {
    String result = endpoint;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }
}

