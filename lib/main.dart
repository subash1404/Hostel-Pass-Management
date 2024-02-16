import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostel_pass_management/pages/login.dart';
import 'package:hostel_pass_management/pages/newpass.dart';
import 'package:hostel_pass_management/pages/profile.dart';
import 'package:hostel_pass_management/pages/splash.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 156, 27, 255),
  ),
  textTheme: GoogleFonts.dmSansTextTheme(),
);

void main() async {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: ProfilePage(),
    );
  }
}
