import 'package:dota2_invoker/providers/services_provider.dart';
import 'package:dota2_invoker/services/database/firestore_service.dart';
import 'package:dota2_invoker/services/local_storage/local_storage_service.dart';

import 'widgets/app_snackbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants/app_strings.dart';
import 'providers/game_provider.dart';
import 'providers/spell_provider.dart';
import 'screens/splash/splash_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  runApp(MultiProvider(
    providers: [
      await ChangeNotifierProvider(create: (context) => ServicesProvider(
        databaseService: FirestoreService.instance, 
        localStorageService: LocalStorageService.instance
      )..initServices()),
      ChangeNotifierProvider(create: (context) => GameProvider()),
      ChangeNotifierProvider(create: (context) => SpellProvider()),
    ],
    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: ThemeData.dark(),
      home: const SplashView(),
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: AppSnackBar.scaffoldMessengerKey,
    );
  }
}
