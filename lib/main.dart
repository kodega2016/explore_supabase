import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hellosupa/pages/startup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final supabaseURL = dotenv.env["SUPABASE_URL"];
  final supabaseKey = dotenv.env["SUPABASE_KEY"];
  await Supabase.initialize(
    url: supabaseURL!,
    anonKey: supabaseKey!,
    debug: false,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          fontFamily: GoogleFonts.play().fontFamily,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
          )),
      home: const StartupPage(),
    );
  }
}
