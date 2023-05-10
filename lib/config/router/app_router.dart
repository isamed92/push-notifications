import 'package:go_router/go_router.dart';
import 'package:push_notifications/presentation/screens/screens.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/notification/:messageId',
    builder: (context, state) => DetailsScreen(
      pushMessageId: state.pathParameters['messageId'] ?? '',
    ),
  ),
]);
