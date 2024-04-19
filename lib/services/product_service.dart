import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/models/product/get_all_product_model.dart';
import 'package:pract_01/models/product/size_model.dart';
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

  Future<GetAllProductsModel> getAllProduct() async {
    try {
      final authToken = await _getAuthToken();

      final response = await _dio.get(
        "${Environment.apiUrl}/products?populate=*&sort=createdAt:DESC",
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            "Content-Type": "application/json",
          },
        ),
      );

      return GetAllProductsModel.fromJson(response.data);
    } catch (error) {
      print('Error in getAllProduct: $error');

      rethrow;
    }
  }

  Future<ProductUpdateModel> updateProduct(int id, double price) async {
    try {
      final authToken = await _getAuthToken();
      final response = await _dio.put(
        "${Environment.apiUrl}/products/$id?populate=*",
        data: {
          "data": {
            "quotation_price": price,
          }
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            "Content-Type": "application/json",
          },
        ),
      );

      return ProductUpdateModel.fromJson(response.data);
    } on DioException catch (error) {
      print('Error in updateProduct: $error');
      rethrow;
    }
  }

  Future<ProductUpdateModel> deleteProduct(int id) async {
    try {
      final authToken = await _getAuthToken();

      final response = await _dio.delete(
        "${Environment.apiUrl}/products/$id?populate=*",
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            "Content-Type": "application/json",
          },
        ),
      );
      return ProductUpdateModel.fromJson(response.data);
    } catch (error) {
      print('Error in deleteProduct: $error');

      rethrow;
    }
  }

  Future<SizeUpdateModel> updateSize(int id, price) async {
    try {
      final authToken = await _getAuthToken();
      final response = await _dio.put(
        "${Environment.apiUrl}/product-sizes/$id?populate=*",
        data: {
          "data": {
            "quotation_price": price,
          }
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            "Content-Type": "application/json",
          },
        ),
      );

      return SizeUpdateModel.fromJson(response.data);
    } on DioException catch (error) {
      print('Error in updateSize: $error');
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
      print('Error in updateQuotation: $error');
      rethrow;
    }
  }
}
