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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2B6777),
          primary: const Color(0xFF2B6777),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2B6777),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2B6777),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      initialRoute: '/', // Default route to start with
      routes: {
        '/profile': (context) => const ProfilePage(), // Named route for ProfilePage
      },
      home: const MyHomePage(),
    );
  }
}
