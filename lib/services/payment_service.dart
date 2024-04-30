import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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

  //-----------cache-------------------------
  Future<void> cachePayments(List<Payment> payments) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> paymentStrings = payments.map((payment) {
      final Map<String, dynamic> paymentJson = payment.toJson();
      return jsonEncode(paymentJson); // Convertir a JSON y luego a String
    }).toList();
    await prefs.setStringList('cached_payments', paymentStrings);
  }

  Future<void> removeCachedPayment(int paymentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Payment> cachedPayments = await getCachedPayments();

    cachedPayments
        .removeWhere((cachedPayment) => cachedPayment.id == paymentId);

    final List<String> paymentStrings = cachedPayments.map((payment) {
      final Map<String, dynamic> paymentJson = payment.toJson();
      return jsonEncode(paymentJson);
    }).toList();

    await prefs.setStringList('cached_payments', paymentStrings);
  }

  Future<List<Payment>> getCachedPayments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? paymentStrings = prefs.getStringList('cached_payments');
    if (paymentStrings == null) {
      return [];
    }

    final List<Payment> payments = paymentStrings.map((paymentString) {
      final Map<String, dynamic> paymentJson =
          jsonDecode(paymentString); // Convertir de String a JSON
      return Payment.fromJson(paymentJson);
    }).toList();

    return payments;
  }
  //-----------end cache-------------------------

  Future<PaymentModel> getPaymentAll() async {
    try {
      final response = await _dio.get(
        "${Environment.apiUrl}/payments?populate=*&sort=createdAt:ASC",
      );

      return PaymentModel.fromJson(response.data);
    } on DioException catch (error) {
      if (kDebugMode) {
        print('Error en getPaymentAll: $error');
      }
      rethrow;
    }
  }

  Future<void> archivePayments(int id) async {
    try {
      final response = await _dio.put(
        "${Environment.apiUrl}/payments/$id",
        data: {
          "data": {"publishedAt": null, 'paymentId': id}
        },
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
        print('Error in archivePayment: $error');
      }
      rethrow;
    }
  }

  Future<void> approvePayments(int paymentId, int quoId, int userId,
      String status, String publishedAt) async {
    try {
      final response = await _dio.put(
        "${Environment.apiUrl}/payments/$paymentId",
        data: {
          "data": {
            "paymentId": paymentId,
            "quotationId": quoId,
            "userId": userId,
            "status": status,
            "publishedAt": publishedAt
          }
        },
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
        print('Error in archivePayment: $error');
      }
      rethrow;
    }
  }
}
