import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignoutButton extends StatelessWidget {
  final Color color;
  const SignoutButton({
    super.key,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.logout,
        color: color,
      ),
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushNamed(context, '/auth');
      },
    );
  }
}
