import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/models/price/get_all_prices_model.dart';
import 'package:pract_01/utils/error_handlers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PriceService {
  late Dio _dio;
  PriceService({required BuildContext context}) {
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

  Future<PriceModel> getAllPrice() async {
    try {
      final authToken = await _getAuthToken();

      final response = await _dio.get(
        "${Environment.apiUrl}/products?sort=name:ASC&populate[thumbnail][populate][0]=data&populate[brand][populate][0]=data&populate[prices][populate][product_colors][populate][0]=data&populate[prices][populate][size][populate][0]=data&populate[prices][populate][categories][populate][0]=data&pagination[page]=1&pagination[pageSize]=999",
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            "Content-Type": "application/json",
          },
        ),
      );

      return PriceModel.fromJson(response.data);
    } catch (error) {
      print('Error in getAllPrice: $error');

      rethrow;
    }
  }
}
