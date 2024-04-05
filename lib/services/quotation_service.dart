import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/models/quotation/archive_quotation_model.dart';
import 'package:pract_01/models/quotation/delete_quotation_model.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart';
import 'package:pract_01/models/quotation/get_details_quotation_model.dart';
// import 'package:pract_01/models/quotation/update_quotation_model.dart';
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

  //-----------cache-------------------------
  Future<void> cacheQuotations(List<Quotation> quotations) async {
    print('response.data cacheQuotations: $quotations');

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> quotationStrings = quotations.map((quotation) {
      final Map<String, dynamic> quotationJson = quotation.toJson();
      return jsonEncode(quotationJson); // Convertir a JSON y luego a String
    }).toList();
    print('Cacheado $quotationStrings');
    await prefs.setStringList('cached_quotations', quotationStrings);
  }

  Future<void> removeCachedQuotation(int quotationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Quotation> cachedQuotations = await getCachedQuotations();

    cachedQuotations
        .removeWhere((cachedQuotation) => cachedQuotation.id == quotationId);

    final List<String> quotationStrings = cachedQuotations.map((quotation) {
      final Map<String, dynamic> quotationJson = quotation.toJson();
      return jsonEncode(quotationJson);
    }).toList();

    await prefs.setStringList('cached_quotations', quotationStrings);
  }

  Future<List<Quotation>> getCachedQuotations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? quotationStrings =
        prefs.getStringList('cached_quotations');
    if (quotationStrings == null) {
      return [];
    }

    print('quotationStrings $quotationStrings');

    final List<Quotation> quotations = quotationStrings.map((quotationString) {
      final Map<String, dynamic> quotationJson =
          jsonDecode(quotationString); // Convertir de String a JSON
      return Quotation.fromJson(quotationJson);
    }).toList();

    return quotations;
  }
  //-----------end cache-------------------------

  Future<QuotationModel> getAllQuotation() async {
    try {
      final response = await _dio.get(
        "${Environment.apiUrl}/quotations?populate=*&sort=createdAt:ASC&pagination[page]=1&pagination[pageSize]=999",
      );
      print('JSON completo: $response');
      return QuotationModel.fromJson(response.data);
    } on DioException catch (error) {
      print('Error en getAllQuotation: $error');
      rethrow;
    }
  }

  Future<void> updateQuotation(int? id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        "${Environment.apiUrl}/quotations/$id?populate=*",
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
