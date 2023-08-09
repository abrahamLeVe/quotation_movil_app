import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void showAuthenticationErrorDialog(BuildContext context, dynamic error) {
  String errorMessage = 'Ocurrió un error. Por favor, inténtelo de nuevo.';

  if (error is DioException) {
    
    if (error.response?.statusCode == 400) {
      errorMessage =
          'Credenciales inválidas. Por favor, verifique su correo y contraseña.';
    } else if (error.response?.statusCode == 401 ||
        error.response?.statusCode == 403) {
      errorMessage =
          'Credenciales inválidas o caducaron. Por favor, inicie sesión nuevamente.';
    } else if (error.response?.statusCode == 404) {
      errorMessage = '¿Desea refrescar la página?';
    } else if (error.response?.statusCode == 500) {
      errorMessage =
          'Ocurrió un error en el servidor. Por favor, inténtelo de nuevo más tarde.';
    } else if (error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||  error.type == DioExceptionType.connectionError) {
      errorMessage =
          'Tiempo de espera de conexión o envío agotado. Por favor, inténtelo de nuevo.';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      errorMessage =
          'Tiempo de espera de recepción agotado. Por favor, inténtelo de nuevo.';
    } else if (error.type == DioExceptionType.cancel) {
      errorMessage =
          'La solicitud fue cancelada. Por favor, inténtelo de nuevo.';
    } else if (error.type == DioExceptionType.unknown) {
      errorMessage =
          'Error de red, o el servidor está apagado. Por favor, inténtelo de nuevo.';
    }
   
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
            '${error.response?.statusCode == 404 ? "Recurso no encontrado" : "¡Error!"} ❌'),
        content: Text(errorMessage),
        actions: <Widget>[
          if (error.response?.statusCode == 404) 
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Volver'),
            ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, '/'); 
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}
