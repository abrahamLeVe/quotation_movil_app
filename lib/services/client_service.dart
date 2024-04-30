import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/client/gat_all_client_model.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/utils/error_handlers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientService {
  late Dio _dio;
  ClientService({required BuildContext context}) {
    _dio = Dio();

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final authToken = await _getAuthToken();
        options.headers['Authorization'] = 'Bearer $authToken';
        options.headers['Content-Type'] = 'application/json';
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        showAuthenticationErrorDialog(context, error);

        return handler.next(error);
      },
    ));
  }

  Future<String> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  Future<List<ClientModel>> getClientAll() async {
    try {
      final response = await _dio.get(
        "${Environment.apiUrl}/users?populate=*",
      );

      List<ClientModel> clients = (response.data as List<dynamic>)
          .map((item) => ClientModel.fromJson(item))
          .toList();

      return clients;
    } on DioException catch (error) {
      if (kDebugMode) {
        print('Error en getClientAll: $error');
      }
      rethrow; // Reenvía la excepción para manejarla en el código que llama a esta función
    }
  }
}
