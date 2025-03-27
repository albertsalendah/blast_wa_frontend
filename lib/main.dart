import 'package:flutter/material.dart';
import 'package:whatsapp_blast/config/routes/route_notifier.dart';
import 'package:whatsapp_blast/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:whatsapp_blast/features/history/presentation/bloc/message_history_bloc.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/bloc/whatsapp_bloc.dart';
import 'config/routes/routes.dart';
import 'config/theme/theme.dart';
import 'core/di/init_dependencies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/whatsapp_api/presentation/bloc/websocket_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => serviceLocator<AuthBloc>()),
      BlocProvider(create: (context) => serviceLocator<WebSocketCubit>()),
      BlocProvider(create: (context) => serviceLocator<WhatsappBloc>()),
      BlocProvider(create: (context) => serviceLocator<MessageHistoryBloc>()),
    ],
    child: BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess ||
            state is LogoutSuccess ||
            state is GetUserDataSuccess) {
          routeNotifier.loadAuthState();
        }
      },
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp Blast',
      theme: AppTheme.darkThemeMode,
      routerConfig: router,
    );
  }
}
