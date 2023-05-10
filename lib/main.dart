import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_notifications/config/router/app_router.dart';
import 'package:push_notifications/config/theme/app_theme.dart';
import 'package:push_notifications/presentation/blocs/notification_bloc/notifications_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationsBloc.initializeFirebaseNotifications();

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => NotificationsBloc(),
    )
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      routerConfig: appRouter,
    );
  }
}
