import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/models/contact/get_all_contact.dart';
import 'package:pract_01/utils/error_handlers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactService {
  late Dio _dio;
  ContactService({required BuildContext context}) {
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
  Future<void> cacheContacts(List<Contact> contacts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> contactStrings = contacts.map((contact) {
      final Map<String, dynamic> contactJson = contact.toJson();
      return jsonEncode(contactJson); // Convertir a JSON y luego a String
    }).toList();
    await prefs.setStringList('cached_contacts', contactStrings);
  }

  Future<void> removeCachedContact(int contactId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Contact> cachedContacts = await getCachedContacts();

    cachedContacts
        .removeWhere((cachedContact) => cachedContact.id == contactId);

    final List<String> contactStrings = cachedContacts.map((contact) {
      final Map<String, dynamic> contactJson = contact.toJson();
      return jsonEncode(contactJson);
    }).toList();

    await prefs.setStringList('cached_contacts', contactStrings);
  }

  Future<List<Contact>> getCachedContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? contactStrings = prefs.getStringList('cached_contacts');
    if (contactStrings == null) {
      return [];
    }

    final List<Contact> contacts = contactStrings.map((contactString) {
      final Map<String, dynamic> contactJson =
          jsonDecode(contactString); // Convertir de String a JSON
      return Contact.fromJson(contactJson);
    }).toList();

    return contacts;
  }
  //-----------end cache-------------------------

  Future<ContactModel> getContactAll() async {
    try {
      final response = await _dio.get(
        "${Environment.apiUrl}/contacts?populate=*&filters[stateMessage][\$eq]=false",
      );
      return ContactModel.fromJson(response.data);
    } on DioException catch (error) {
      if (kDebugMode) {
        print('Error en getContactAll: $error');
      }
      rethrow;
    }
  }

  Future<void> updateContactService(int? id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        "${Environment.apiUrl}/contacts/$id",
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
        print('Error in updateContact: $error');
      }
      rethrow;
    }
  }
}
