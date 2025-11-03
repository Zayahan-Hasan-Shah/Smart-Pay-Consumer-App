class ApiUrl {
  // static const String baseUrl = 'http://192.168.100.154:5030';
  static const String baseUrl = 'http://10.0.2.2:5151';
  static const String signupUrl = '$baseUrl/api/Auth/signup';
  static const String loginUrl = '$baseUrl/api/Auth/login';
  static const String refreshTokenUrl = '$baseUrl/api/Auth/refresh';
  static const String logoutUrl = '$baseUrl/api/Auth/logout';
  static const String getBillsByConsumerNoUrl = '$baseUrl/api/Bills/bill/';
  static const String registerConsumerNoUrl = '$baseUrl/api/ConsumerNumber/register';
  static const String getConsumerNoOfUser = '$baseUrl/api/ConsumerNumber/user/';
  static const String setReminderUrl = '$baseUrl/api/Reminders/SetReminders';
  static const String getReminderUrl = '$baseUrl/api/Reminders';
  static const String editReminderUrl = '$baseUrl/api/Reminders';
}

