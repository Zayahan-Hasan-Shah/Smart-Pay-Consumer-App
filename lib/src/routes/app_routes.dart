import 'package:consumer_app/src/routes/route_names.dart';
import 'package:consumer_app/src/view/screens/auth/forgot_password_screen.dart';
import 'package:consumer_app/src/view/screens/auth/login_screen.dart';
import 'package:consumer_app/src/view/screens/auth/signup_screen.dart';
import 'package:consumer_app/src/view/screens/bottom_navigation/bill_screen/bill_detail_screen.dart';
import 'package:consumer_app/src/view/screens/bottom_navigation/bill_screen/bill_screen.dart';
import 'package:consumer_app/src/view/screens/bottom_navigation/dashboard_screen/dashboard_screen.dart';
import 'package:consumer_app/src/view/screens/bottom_navigation/landing_page.dart';
import 'package:consumer_app/src/view/screens/bottom_navigation/profile_screen/profile_screen.dart';
import 'package:consumer_app/src/view/screens/bottom_navigation/setting_screen/setting_screen.dart';
import 'package:consumer_app/src/view/screens/bottom_navigation/transaction_screen/transaction_detail_screen.dart';
import 'package:consumer_app/src/view/screens/bottom_navigation/transaction_screen/transaction_screen.dart';
import 'package:consumer_app/src/view/screens/notification/notification_screen.dart';
import 'package:consumer_app/src/view/screens/on_boarding/splash_screen.dart';
import 'package:consumer_app/src/view/screens/reminders/reminder_screen.dart';
import 'package:get/get_navigation/get_navigation.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: RouteNames.splashScreen, page: () => const SplashScreen()),
    GetPage(name: RouteNames.signupScreen, page: () => const SignupScreen()),
    GetPage(name: RouteNames.loginScreen, page: () => const LoginScreen()),
    GetPage(name: RouteNames.forgotPasswordScreen, page: () => const ForgotPasswordScreen()),
    GetPage(name: RouteNames.landingPageScreen, page: () => const LandingPage()),
    GetPage(name: RouteNames.dashboardScreen, page: () => const DashboardScreen()),
    GetPage(name: RouteNames.billScreen, page: () => const BillScreen()),
    GetPage(name: RouteNames.billDetailScreen, page: () => const BillDetailScreen()),
    GetPage(name: RouteNames.transactionScreen, page: () => const TransactionScreen()),
    GetPage(name: RouteNames.transactionDetailScreen, page: () => const TransactionDetailScreen()),
    GetPage(name: RouteNames.profileScreen, page: () => const ProfileScreen()),
    GetPage(name: RouteNames.settingScreen, page: () => const SettingScreen()),
    GetPage(name: RouteNames.notificationScreen, page: () => const NotificationScreen()),
    GetPage(name: RouteNames.reminderScreen, page: () => const ReminderScreen()),
  ];
}
