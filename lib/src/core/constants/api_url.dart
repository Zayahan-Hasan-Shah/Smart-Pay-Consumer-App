class ApiUrl {
  static const String baseUrl = 'http://192.168.100.154:5030';
  static const String signupUrl = '$baseUrl/api/Auth/signup';
  static const String loginUrl = '$baseUrl/api/Auth/login';
  static const String refreshTokenUrl = '$baseUrl/api/Auth/refresh';
  static const String logoutUrl = '$baseUrl/api/Auth/logout';
  static const String getBillsByConsumerNoUrl = '$baseUrl/api/Bills/bill/';
  static const String registerConsumerNoUrl = '$baseUrl/api/ConsumerNumber/register';
  static const String getConsumerNoOfUser = '$baseUrl/api/ConsumerNumber/user/';
}

