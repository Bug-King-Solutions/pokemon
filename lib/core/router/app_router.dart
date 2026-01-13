import 'package:go_router/go_router.dart';
import '../../presentation/screens/today/today_screen.dart';
import '../../presentation/screens/dex/dex_screen.dart';
import '../../presentation/screens/detail/detail_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/about/about_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/today',
    debugLogDiagnostics: false,
    errorBuilder: (context, state) => const TodayScreen(),
    routes: [
      GoRoute(
        path: '/today',
        name: 'today',
        builder: (context, state) => const TodayScreen(),
      ),
      GoRoute(
        path: '/dex',
        name: 'dex',
        builder: (context, state) => const DexScreen(),
      ),
      GoRoute(
        path: '/detail/:id',
        name: 'detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DetailScreen(flowerMonId: id);
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  );
}
