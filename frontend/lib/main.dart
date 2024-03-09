import 'package:flutter/material.dart';
import 'package:hostel_pass_management/pages/common/splash_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostel_pass_management/pages/student/aa.dart';
import 'package:hostel_pass_management/pages/student/new_pass_page.dart';
import 'package:hostel_pass_management/utils/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 156, 27, 255),
  ),
  textTheme: GoogleFonts.redactedScriptTextTheme(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesManager.init();
  await dotenv.load();
  runApp(
    const ProviderScope(child: App()),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.amikoTextTheme(),
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0x002e4c)),
        useMaterial3: true,
      ),
      home: SplashPage(),
    );
  }
}
