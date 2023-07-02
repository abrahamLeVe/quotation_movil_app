import 'package:dio/dio.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/models/product_model.dart';
import 'package:pract_01/models/quotation_model.dart';

class NetworkManager {
  late Dio _dio;
  NetworkManager() {
    _dio = Dio();
  }

  Map<String, String> get headers => {
        'Authorization': 'Bearer ${Environment.apiToken}',
        "Content-Type": "application/json",
      };

  Future<QuotationModel> getAll() async {
    final response = await _dio.get(
      "${Environment.apiUrl}/quotations?populate=*",
      options: Options(headers: headers),
    );
    return QuotationModel.fromJson(response.data);
  }

  Future<ProductModel> getAllProduct() async {
    final response = await _dio.get(
      "${Environment.apiUrl}/products?populate=*",
      options: Options(headers: headers),
    );
    return ProductModel.fromJson(response.data);
  }
}
