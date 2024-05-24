import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as firebase;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tamir_kolay/features/home/home_view.dart';
import 'package:tamir_kolay/features/vehicle_registration/vehicle_registration_view.dart';

class AuthenticationView extends ConsumerStatefulWidget {
  const AuthenticationView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthenticationViewState();
}

class _AuthenticationViewState extends ConsumerState<AuthenticationView> {
  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser?.uid ?? 'no uid');

    if (FirebaseAuth.instance.currentUser != null) {
      return const HomeView();
    }

    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'Tamir Kolay',
            style: context.general.textTheme.displayLarge,
          ),
        ),
        SizedBox(
          height: 50.h,
          width: 100.w,
          child: firebase.FirebaseUIActions(
              actions: [
                AuthStateChangeAction<SignedIn>(
                  (context, state) {
                    if (state.user != null) {
                      Navigator.pushNamed(context, '/home');
                    }
                  },
                ),
                AuthStateChangeAction<SigningUp>((context, state) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeView()));
                }),
              ],
              child: firebase.SignInScreen(
                providers: [firebase.EmailAuthProvider()],
              )),
        ),
      ],
    ));
  }
}
