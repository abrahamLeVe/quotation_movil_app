import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/auth_model.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/utils/error_handlers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  late Dio _dio;

  AuthenticationService({required BuildContext context}) {
    _dio = Dio();

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers['Authorization'] = '';
        options.headers['Content-Type'] = 'application/json';
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        showAuthenticationErrorDialog(context, error);

        return handler.next(error);
      },
    ));
  }

  Map<String, String> get headers => {
        'Authorization': '',
        "Content-Type": "application/json",
      };

  Future<AuthModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        "${Environment.apiUrl}/auth/local",
        data: {
          "identifier": email,
          "password": password,
        },
      );
      if (kDebugMode) {
        print('Error in login: $response');
      }
      final authToken = response.data['jwt'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('auth_token', authToken);
      return AuthModel.fromJson(response.data);
    } catch (error) {
      if (kDebugMode) {
        print('Error in login: $error');
      }

      rethrow;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
