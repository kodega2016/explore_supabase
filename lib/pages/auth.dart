import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthType { login, register }

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final key = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthType _authType = AuthType.login;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Form(
            key: key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  enabled: !_isLoading,
                  validator: (val) =>
                      (val?.isEmpty ?? false) ? "username is required" : null,
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                  ),
                ),
                TextFormField(
                  enabled: !_isLoading,
                  validator: (val) =>
                      (val?.isEmpty ?? false) ? "password is required" : null,
                  textInputAction: TextInputAction.done,
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () async => await loginOrRegister(),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            _authType == AuthType.login ? 'Login' : 'Register',
                          ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _authType = _authType == AuthType.login
                          ? AuthType.register
                          : AuthType.login;
                      _emailController.clear();
                      _passwordController.clear();
                    });
                  },
                  child: Text(
                    _authType == AuthType.login
                        ? "Don't have an account? Register"
                        : "Already an user? Login",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginOrRegister() async {
    if (key.currentState?.validate() ?? false) {
      try {
        _isLoading = true;
        setState(() {});
        if (_authType == AuthType.login) {
          await Supabase.instance.client.auth.signInWithPassword(
            password: password,
            email: email,
          );
        } else {
          await Supabase.instance.client.auth.signUp(
            password: password,
            email: email,
          );
        }
      } on AuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
