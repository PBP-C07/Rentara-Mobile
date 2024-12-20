import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:rentara_mobile/pages/main/screens/profile.dart';
import 'pages/main/screens/home.dart';

void main() {
  runApp(const MyProviderApp());
}

class MyProviderApp extends StatelessWidget {
  const MyProviderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => CookieRequest(),
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rentara+',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/profile': (context) => const ProfilePage(),
      },
      home: const MyHomePage(),
    );
  }
}
