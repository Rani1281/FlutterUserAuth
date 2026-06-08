import 'package:articly/data/services/auth_service.dart';
import 'package:articly/presentation/authentication/view_models/auth_page_model.dart';
import 'package:articly/presentation/authentication/widgets/auth_page.dart';
import 'package:articly/theme/app_bar_theme.dart';
import 'package:articly/theme/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
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
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
        appBarTheme: appBarTheme,
      ),
      home: AuthPage(viewModel: AuthPageModel(service: AuthService())),
    );
  }
}
