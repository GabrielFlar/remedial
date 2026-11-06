import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'theme/clay.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const VetApp());
}

class VetApp extends StatelessWidget {
  const VetApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final initialHome = (user != null && !user.isAnonymous)
        ? const HomeScreen()
        : const LoginScreen();

    return MaterialApp(
      title: 'VetClay - Pacientes',
      debugShowCheckedModeBanner: false,
      theme: clayTheme(),
      home: initialHome,
    );
  }
}
