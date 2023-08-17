import 'package:flutter/material.dart';
import 'package:pract_01/screens/quotation/quotation_actions.dart';
import 'package:pract_01/services/authentication_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoggingIn = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _login(BuildContext context) async {
    if (_isLoggingIn) {
      return;
    }

    setState(() {
      _isLoggingIn = true;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final authService = AuthenticationService(context: context);
      await authService.login(email, password);
      // ignore: use_build_context_synchronously
      await updateQuotationsInBackground(context);

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Inicio de sesión exitoso'),
              content: const Text('Autorizado'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false);
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
    } finally {
      setState(() {
        _isLoggingIn = false; // Finalizar el proceso de inicio de sesión
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoggingIn ? null : () => _login(context),
                child: _isLoggingIn
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
