import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_colors.dart';
import 'core/router/app_router.dart';
import 'core/utils/shared_prefs_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        useMaterial3: true,
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed) || states.contains(WidgetState.hovered)) {
                return AppColors.menuBgBlue;
              }
              return null;
            }),
            foregroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed) || states.contains(WidgetState.hovered)) {
                return AppColors.primaryBlueStart;
              }
              return AppColors.textPrimary;
            }),
          ),
        ),
      ),
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
