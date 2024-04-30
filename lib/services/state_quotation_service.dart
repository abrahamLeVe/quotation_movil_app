import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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

  Future<void> initializeStates() async {
    final cachedStates = await getCachedDataStates();
    if (cachedStates.isEmpty) {
      final stateModel = await getState();
      await cacheDataStates(stateModel.data);
    }
  }

  Future<StateModel> getState() async {
    try {
      final cachedStates = await getCachedDataStates();
      if (cachedStates.isNotEmpty) {
        return StateModel(data: cachedStates);
      }
      final response = await _dio.get("${Environment.apiUrl}/states");
      final fetchedStates = StateModel.fromJson(response.data).data;
      await cacheDataStates(fetchedStates);
      return StateModel(data: fetchedStates);
    } on DioException catch (error) {
      if (kDebugMode) {
        print('Error en getState: $error');
      }
      rethrow;
    }
  }

  //-----------cache-------------------------
  Future<void> cacheDataStates(List<DataState> dataStates) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> dataStateStrings = dataStates.map((dataState) {
      final Map<String, dynamic> dataStateJson = dataState.toJson();
      return jsonEncode(dataStateJson); // Convertir a JSON y luego a String
    }).toList();
    await prefs.setStringList('cached_dataStates', dataStateStrings);
  }

  Future<void> removeCachedDataState(int dataStateId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<DataState> cachedDataStates = await getCachedDataStates();

    cachedDataStates
        .removeWhere((cachedDataState) => cachedDataState.id == dataStateId);

    final List<String> dataStateStrings = cachedDataStates.map((dataState) {
      final Map<String, dynamic> dataStateJson = dataState.toJson();
      return jsonEncode(dataStateJson);
    }).toList();

    await prefs.setStringList('cached_dataStates', dataStateStrings);
  }

  Future<List<DataState>> getCachedDataStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? dataStateStrings =
        prefs.getStringList('cached_dataStates');
    if (dataStateStrings == null) {
      return [];
    }

    final List<DataState> dataStates = dataStateStrings.map((dataStateString) {
      final Map<String, dynamic> dataStateJson = jsonDecode(dataStateString);
      return DataState.fromJson(dataStateJson);
    }).toList();

    return dataStates;
  }
}
