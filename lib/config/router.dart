import 'package:gemstore_frontend/screens/auth/login_screen.dart';
import 'package:gemstore_frontend/screens/home/home_screen.dart';
import 'package:gemstore_frontend/screens/home/setting_screen.dart';
import 'package:go_router/go_router.dart';

class RouteName {
  static const String home = '/home';
  static const String login = '/login';
  static const String settings = '/settings';
  
}



final router = GoRouter(
  initialLocation: RouteName.login,
  routes: [
    GoRoute(
      path: RouteName.login,
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: RouteName.home,
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: RouteName.settings,
      builder: (context, state) {
        return const SettingsScreen();
      },
    ),
  ],
);
