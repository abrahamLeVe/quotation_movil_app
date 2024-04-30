import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/enviroment_model.dart';

class FcmService {
  late Dio _dio;
  FcmService({required BuildContext context}) {
    _dio = Dio();

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final fcmToken = Environment.fcmToken.toString();
        options.headers['Authorization'] = 'Bearer $fcmToken';
        options.headers['Content-Type'] = 'application/json';
        return handler.next(options);
      },
    ));
  }

  Future<void> postFcmToken(String token) async {
    try {
      final response = await _dio.post(
        "${Environment.apiUrl}/fcms",
        data: {
          "data": {"token": token}
        },
      );
      if (kDebugMode) {
        print("Response status postFcmToken: ${response.statusCode}");
      }
    } on DioException catch (error) {
      if (kDebugMode) {
        print('Error in postFcmToken: ${error.message}');
      }
    }
  }
}
