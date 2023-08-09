import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/models/quotation/archive_quotation_model.dart';
import 'package:pract_01/models/quotation/delete_quotation_model.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart';
import 'package:pract_01/models/quotation/get_details_quotation_model.dart';
import 'package:pract_01/models/quotation/update_quotation_model.dart';
import 'package:pract_01/utils/error_handlers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuotationService {
  late Dio _dio;

  QuotationService({required BuildContext context}) {
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

  Future<QuotationModel> getAllQuotation() async {
    try {
      final response = await _dio.get(
        "${Environment.apiUrl}/quotations?populate=*&sort=createdAt:DESC",
      );

      return QuotationModel.fromJson(response.data);
    } on DioException catch (error) {
      print('Error in getAllQuotation: $error');
      rethrow;
    }
  }

  Future<UpdateQuotationModel> updateQuotation(
      int? id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        "${Environment.apiUrl}/quotations/$id?populate=*",
        data: data,
      );

      return UpdateQuotationModel.fromJson(response.data);
    } on DioException catch (error) {
      print('Error in updateQuotation: $error');
      rethrow;
    }
  }

  Future<GetDetailsQuotation> getDetailsQuotation(int id) async {
    try {
      final response = await _dio.get(
        "${Environment.apiUrl}/quotations/$id?populate=*",
      );
      return GetDetailsQuotation.fromJson(response.data);
    } on DioException catch (error) {
      print('Error in getDetailsQuotation: $error');
      rethrow;
    }
  }

  Future<DeleteQuotation> deleteQuotation(int id) async {
    try {
      final response = await _dio.delete(
        "${Environment.apiUrl}/quotations/$id?populate=*",
      );
      return DeleteQuotation.fromJson(response.data);
    } on DioException catch (error) {
      print('Error in deleteQuotation: $error');
      rethrow;
    }
  }

  Future<ArchiveQuotation> archiveQuotation(int id) async {
    try {
      final response = await _dio.put(
        "${Environment.apiUrl}/quotations/$id?populate=*",
        data: {
          "data": {
            "publishedAt": null,
          }
        },
      );
      return ArchiveQuotation.fromJson(response.data);
    } on DioException catch (error) {
      print('Error in archiveQuotation: $error');
      rethrow;
    }
  }
}
