import 'package:flutter/material.dart';
import 'package:pract_01/providers/dataState_state.dart';
import 'package:pract_01/services/authentication_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoggingIn = false;
  bool _showPassword = false;

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
      if (context.mounted) {
        Provider.of<DataStateState>(context, listen: false)
            .loadNewDataStates(context);
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
        _isLoggingIn = false;
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
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  'assets/logo_app.png',
                  width: 200,
                  height: 80,
                  fit: BoxFit.fill,
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Usuario'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
