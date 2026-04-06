import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Logo

            // Header Text's

            // logIn/ signUp Container

          ],
        ),
      ),
    );
  }
}

Widget _authLogo() {
  return Container();
}

Widget _authHeaderTexts() {
  return Container();
}

Widget _AuthConatiner() {
  return Container();
}