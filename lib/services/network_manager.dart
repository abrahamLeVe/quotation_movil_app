import 'package:dio/dio.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/models/product_model.dart';
import 'package:pract_01/models/quotation_model.dart';
import 'package:pract_01/models/size_model.dart';

class NetworkManager {
  late Dio _dio;
  NetworkManager() {
    _dio = Dio();
  }


  Map<String, String> get headers => {
        'Authorization': 'Bearer ${Environment.apiToken}',
        "Content-Type": "application/json",
      };

//Quotation
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

//Product
  Future<ProductUpdateModel> updateProduct(int id, double price) async {
    try {
      final response = await _dio.put(
        "${Environment.apiUrl}/products/$id?populate=*",
        data: {
          "data": {
            "quotation_price": price,
          }
        },
        options: Options(headers: headers),
      );
      return ProductUpdateModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<ProductUpdateModel> deleteProduct(int id) async {
    try {
      final response = await _dio.delete(
        "${Environment.apiUrl}/products/$id?populate=*",
        options: Options(headers: headers),
      );
      return ProductUpdateModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  //Product_size
  Future<SizeUpdateModel> updateSize(int id,    price) async {
    try {
      final response = await _dio.put(
        "${Environment.apiUrl}/product-sizes/$id?populate=*",
        data: {
          "data": {
            "quotation_price": price,
          }
        },
        options: Options(headers: headers),
      );
      return SizeUpdateModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  } 
}


