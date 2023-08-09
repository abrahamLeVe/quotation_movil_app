import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  AuthGuard({required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuthentication(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.data == true) {
            // El usuario está autenticado, permitir el acceso a la pantalla
            return child;
          } else {
            // El usuario no está autenticado, redirigir a la pantalla de inicio de sesión
            Navigator.pushReplacementNamed(context, '/');
            return SizedBox.shrink();
          }
        }
      },
    );
  }

  Future<bool> _checkAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');

    if (authToken != null) {
      // Aquí puedes implementar tu lógica para verificar si el token es válido, por ejemplo, verificar su expiración
      // Por simplicidad, aquí asumiremos que un token no expirado es válido
      return true;
    } else {
      return false;
    }
  }
}
