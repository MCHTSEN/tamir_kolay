import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tamir_kolay/features/auth/authentication_view.dart';
import 'package:tamir_kolay/features/home/home_view.dart';
import 'package:tamir_kolay/features/payment/payment_view.dart';
import 'package:tamir_kolay/features/vehicle_registration/vehicle_registration_view.dart';
import 'package:tamir_kolay/firebase_options.dart';
import 'package:tamir_kolay/utils/constants/api_keys.dart';
import 'package:tamir_kolay/utils/theme/color_theme.dart';
import 'package:tamir_kolay/utils/theme/text_theme.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Merriweather", "Ubuntu");
    MaterialTheme theme = MaterialTheme(textTheme);
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          home: const AuthenticationView(),
          routes: {
            '/payment': (context) => const PaymentView(),
            '/registration': (context) => const VehicleRegistrationView(),
            '/home': (context) => const HomeView(),
          },
          theme:
              (brightness == Brightness.light) ? theme.light() : theme.dark(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
