import 'package:clarioflutter/src/auth/SignUp.dart';
import 'package:clarioflutter/src/home/home.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clario',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/signup': (context) => const SignUp(),
      },
    );
  }
}
