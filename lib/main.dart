import 'package:articly/presentation/authentication/widgets/auth_page.dart';
import 'package:articly/theme/app_bar_theme.dart';
import 'package:articly/theme/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:logging/logging.dart';

void setupLogging() {
  Logger.root.level = Level.ALL;

  Logger.root.onRecord.listen((record) {
    debugPrint(
      '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}',
    );
  });
}

void main() async {
  setupLogging();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ! Return Home screen, Auth page or email verification page
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
        appBarTheme: appBarTheme,
      ),
      home: const AuthPage(),
    );
  }
}
