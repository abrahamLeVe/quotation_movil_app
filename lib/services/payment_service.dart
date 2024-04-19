import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/models/payment/get_all_payment.dart';
import 'package:pract_01/utils/error_handlers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentService {
  late Dio _dio;
  PaymentService({required BuildContext context}) {
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

  Future<PaymentModel> getPaymentAll() async {
    try {
      final response = await _dio.get(
        "${Environment.apiUrl}/payments?populate=*&sort=createdAt:ASC&pagination[page]=1&pagination[pageSize]=999",
      );
      print('getPaymentAll completo: $response');
      return PaymentModel.fromJson(response.data);
    } on DioException catch (error) {
      print('Error en getPaymentAll: $error');
      rethrow;
    }
  }
}
