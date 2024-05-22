import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tamir_kolay/features/auth/authentication_view.dart';
import 'package:tamir_kolay/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthenticationView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
