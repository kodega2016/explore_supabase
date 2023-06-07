import 'package:flutter/material.dart';
import 'package:hellosupa/pages/auth.dart';
import 'package:hellosupa/pages/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  User? _user;
  final SupabaseClient client = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _getAndSetUser();
  }

  Future<void> _getAndSetUser() async {
    _user = client.auth.currentUser;
    setState(() {});
    client.auth.onAuthStateChange.listen((event) {
      _user = event.session?.user;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return _user == null ? const AuthPage() : const HomePage();
  }
}
