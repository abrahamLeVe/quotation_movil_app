import 'package:dio/dio.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/models/quotation/archive_quotation_model.dart';
import 'package:pract_01/models/quotation/delete_quotation_model.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart';
import 'package:pract_01/models/quotation/get_details_quotation_model.dart';
import 'package:pract_01/models/quotation/update_quotation_model.dart';

class QuotationService {
  late Dio _dio;

  QuotationService() {
    _dio = Dio();
  }

  Map<String, String> get headers => {
        'Authorization': 'Bearer ${Environment.apiToken}',
        "Content-Type": "application/json",
      };

  Future<QuotationModel> getAllQuotation() async {
    try {
      final response = await _dio.get(
        "${Environment.apiUrl}/quotations?populate=*&sort=createdAt:DESC",
        options: Options(headers: headers),
      );

      return QuotationModel.fromJson(response.data);
    } catch (error) {
      print('Error in updateQuotation: $error');
      rethrow;
    }
  }

  Future<UpdateQuotationModel> updateQuotation(
      int? id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        "${Environment.apiUrl}/quotations/$id?populate=*",
        data: data,
        options: Options(headers: headers),
      );
      return UpdateQuotationModel.fromJson(response.data);
    } catch (error) {
      print('Error in updateQuotation: $error');
      rethrow;
    }
  }

  Future<GetDetailsQuotation> getDetailsQuotation(int id) async {
    try {
      final response = await _dio.get(
        "${Environment.apiUrl}/quotations/$id?populate=*",
        options: Options(headers: headers),
      );
      return GetDetailsQuotation.fromJson(response.data);
    } catch (error) {
      print('Error in getDetailsQuotation: $error');
      rethrow;
    }
  }

  Future<DeleteQuotation> deleteQuotation(int id) async {
    try {
      final response = await _dio.delete(
        "${Environment.apiUrl}/quotations/$id?populate=*",
        options: Options(headers: headers),
      );
      return DeleteQuotation.fromJson(response.data);
    } catch (error) {
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
        options: Options(headers: headers),
      );
      return ArchiveQuotation.fromJson(response.data);
    } catch (error) {
      print('Error in archiveQuotation: $error');
      rethrow;
    }
  }
}
