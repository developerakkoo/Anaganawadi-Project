import 'package:flutter/material.dart';
import 'package:mindlabryinth/providers/auth_provider.dart';
import 'package:mindlabryinth/screens/child_register.dart';
import 'package:mindlabryinth/screens/dashboard.dart';
import 'package:mindlabryinth/screens/login_family_screen.dart';
import 'package:mindlabryinth/screens/staff_register.dart';
import 'package:mindlabryinth/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AuthProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/familyRegistration': (context) => LoginFamilyScreen(),
        '/staffRegistration': (context) => RegisterStaffScreen(),
        '/childRegistration': (context) => RegisterChildScreen(),
        '/dashboard': (context) => DashScreen(),
      },
    );
  }
}
