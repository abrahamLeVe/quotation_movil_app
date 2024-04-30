import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/utils/error_handlers.dart';

class MercadoPagoService {
  late Dio _dio;
  MercadoPagoService({required BuildContext context}) {
    _dio = Dio();

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final authToken = Environment.mercadoPagoAccessToken.toString();
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

  Future<Map<String, dynamic>> getPayMPDetails(int id) async {
    try {
      final response = await _dio.get(
        "${Environment.apiMercadoPagoUrl}/v1/payments/$id",
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      final responseData = response.data as Map<String, dynamic>;
      final errorMessage = responseData['message'] ?? 'Error desconocido';

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: errorMessage,
      );
    } on DioException catch (error) {
      if (kDebugMode) {
        print('Error in updateQuotation: $error');
      }
      rethrow;
    }
  }
}
