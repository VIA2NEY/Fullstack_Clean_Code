import 'package:clean_architecture_mobile/models/api_response.dart';
import 'package:clean_architecture_mobile/models/product.dart';
import 'package:clean_architecture_mobile/service/api_service.dart';
import 'package:clean_architecture_mobile/utils/constant_api.dart';

class ProductRepository {
  
  final ApiService apiService;

  ProductRepository({required this.apiService});


  Future<ApiResponse<List<Product>>> fetchAllProducts(/*String token*/) async {
    const apiURL = '${ConstantApi.baseURL}/products/';
    
    return apiService.fetchAllProducts(apiURL/*, token: token*/);
    
  }
  

//   Future<ApiResponse<Product>> fetchProductDetails(String token, String id) async {
//     final apiURL = '${ConstantApi.baseURL}/products/$id';
    
//     return apiService.fetchAllProducts(apiURL, token: token);
    
//   }
  

}