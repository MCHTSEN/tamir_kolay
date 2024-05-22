import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as firebase;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tamir_kolay/features/home/home_view.dart';

class AuthenticationView extends ConsumerStatefulWidget {
  const AuthenticationView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthenticationViewState();
}

class _AuthenticationViewState extends ConsumerState<AuthenticationView> {
  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser?.uid ?? 'dsadas');
    return Scaffold(
        body: firebase.FirebaseUIActions(
            actions: [
          AuthStateChangeAction<SignedIn>(
            (context, state) {
              if (state.user != null) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const HomeView(),
                ));
              }
            },
          ),
          AuthStateChangeAction<SigningUp>((context, state) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeView()));
          }),
        ],
            child: firebase.SignInScreen(
              providers: [firebase.EmailAuthProvider()],
            )));
  }
}
