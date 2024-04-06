import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/models/state/state_model.dart';
import 'package:pract_01/utils/error_handlers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateService {
  late Dio _dio;
  StateService({required BuildContext context}) {
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

  Future<StateModel> getState() async {
    try {
      final response = await _dio.get(
        "${Environment.apiUrl}/states",
      );
      print('getState completo: $response');
      return StateModel.fromJson(response.data);
    } on DioException catch (error) {
      print('Error en getAllQuotation: $error');
      rethrow;
    }
  }
}
