import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/vehicle_repository_impl.dart';
import '../landing/landing_page.dart';
import '../vehicles/vehicle_page.dart';
import '../../presentation/blocs/auth_cubit.dart';
import '../../presentation/blocs/vehicle_cubit.dart';

class VmsApp extends StatefulWidget {
  final AuthRepositoryImpl authRepository;
  final VehicleRepositoryImpl vehicleRepository;

  const VmsApp({
    super.key,
    required this.authRepository,
    required this.vehicleRepository,
  });

  @override
  State<VmsApp> createState() => _VmsAppState();
}

class _VmsAppState extends State<VmsApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthCubit(repository: widget.authRepository)..restoreSession(),
        ),
        BlocProvider(
          create: (_) => VehicleCubit(repository: widget.vehicleRepository),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeMode,
        home: AuthGate(
          isDarkMode: _themeMode == ThemeMode.dark,
          onToggleTheme: () => setState(() {
            _themeMode = _themeMode == ThemeMode.dark
                ? ThemeMode.light
                : ThemeMode.dark;
          }),
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const AuthGate({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.checking) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.status == AuthStatus.authenticated) {
          return VehiclePage(
            isDarkMode: isDarkMode,
            onToggleTheme: onToggleTheme,
          );
        }
        return LandingPage(
          isDarkMode: isDarkMode,
          onToggleTheme: onToggleTheme,
        );
      },
    );
  }
}
