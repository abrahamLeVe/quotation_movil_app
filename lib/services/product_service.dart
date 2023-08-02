import 'package:dio/dio.dart';
import 'package:pract_01/models/enviroment_model.dart';
import 'package:pract_01/models/product/get_all_product_model.dart';
import 'package:pract_01/models/product/size_model.dart';

class ProductService {
  late Dio _dio;
  ProductService() {
    _dio = Dio();
  }

  Map<String, String> get headers => {
        'Authorization': 'Bearer ${Environment.apiToken}',
        "Content-Type": "application/json",
      };

  Future<GetAllProductsModel> getAllProduct() async {
    try {
      final response = await _dio.get(
        "${Environment.apiUrl}/products?populate=*&sort=createdAt:DESC",
        options: Options(headers: headers),
      );
      return GetAllProductsModel.fromJson(response.data);
    } catch (error) {
      print('Error in getAllProduct: $error');

      rethrow;
    }
  }

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
      print('Error in updateProduct: $error');

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
      print('Error in deleteProduct: $error');

      rethrow;
    }
  }

  Future<SizeUpdateModel> updateSize(int id, price) async {
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
      print('response in updateSize: $response');

      return SizeUpdateModel.fromJson(response.data);
    } catch (error) {
      print('Error in updateSize: $error');

      rethrow;
    }
  }
}
