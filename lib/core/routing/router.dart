import 'package:go_router/go_router.dart';

import '../../ui/screens/screens.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [GoRoute(path: '/', builder: (context, state) => SplashScreen())],
);
