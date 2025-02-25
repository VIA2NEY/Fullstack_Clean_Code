import 'dart:convert';

import 'package:clean_architecture_mobile/models/api_response.dart';
import 'package:clean_architecture_mobile/models/product.dart';
import 'package:clean_architecture_mobile/utils/api_header.dart';
import 'package:http/http.dart' as http;

class ApiService {
  
  

  Future<ApiResponse<List<Product>>> fetchAllProducts(
    String url/*,
    {required String token}*/
    ) async {
      final uri = Uri.parse(url);
      // final headers = ApiHeaders.getHeadersWithToken(token);
      final headers = ApiHeaders.getHeaders();

      final response = await http.get(uri, headers: headers);
      final dataDecoded = json.decode(response.body);
      
      if (response.statusCode == 200) {
        try {
        List<Product> products = (dataDecoded['data'] as List)
            .map((item) => Product.fromMap(item))
            .toList();
        return ApiResponse<List<Product>>(
          code: dataDecoded['code'],
          message: dataDecoded['message'],
          data: products,
        );
      } catch (e) {
        return ApiResponse<List<Product>>(
          code: dataDecoded['code'] ?? 500,
          message: 'Erreur lors de la conversion des données : $e',
        );
      }
    } else {
      // print("Erreur dans la structure de la réponse ou code HTTP invalide.");
      return ApiResponse<List<Product>>(
        code: dataDecoded['code'] ?? 500,
        message: dataDecoded['message'] ?? 'Erreur inattendue',
      );
    }
    
  }
  

  Future<ApiResponse<Product>> fetchProductsDetails(String url) async {
    final uri = Uri.parse(url);
    final headers = ApiHeaders.getHeaders();

    final response = await http.get(uri, headers: headers);
    final dataDecoded = json.decode(response.body);
    
    if (response.statusCode == 200) {
      try {
        Product products = Product.fromMap(dataDecoded['data']);
        return ApiResponse<Product>(
          code: dataDecoded['code'],
          message: dataDecoded['message'],
          data: products,
        );
      } catch (e) {
        return ApiResponse<Product>(
          code: dataDecoded['code'] ?? 500,
          message: 'Exception lors de la conversion des données : $e',
        );
      }
    } else {
      
      return ApiResponse<Product>(
        code: dataDecoded['code'] ?? 500,
        message: dataDecoded['message'] ?? 'Erreur inattendue',
      );
    }
    
  }


}