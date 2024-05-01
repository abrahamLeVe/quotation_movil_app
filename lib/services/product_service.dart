import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/models/product/get_all_product_model.dart';
import 'package:pract_01/utils/error_handlers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  late Dio _dio;
  ProductService({required BuildContext context}) {
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

  Future<ProductModel> getAllProduct() async {
    try {
      final authToken = await _getAuthToken();

      final response = await _dio.get(
        "${Environment.apiUrl}/products?populate=*&sort=name:ASC&pagination[page]=1&pagination[pageSize]=999",
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            "Content-Type": "application/json",
          },
        ),
      );

      return ProductModel.fromJson(response.data);
    } catch (error) {
      if (kDebugMode) {
        print('Error in getAllProduct: $error');
      }

      rethrow;
    }
  }

  Future<void> updatePrice(int? id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        "${Environment.apiUrl}/prices/$id?populate=*",
        data: data,
      );

      if (response.statusCode == 200) {
        return;
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
