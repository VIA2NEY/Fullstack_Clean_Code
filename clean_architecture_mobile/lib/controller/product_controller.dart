import 'package:clean_architecture_mobile/models/api_response.dart';
import 'package:clean_architecture_mobile/models/product.dart';
import 'package:clean_architecture_mobile/repository/product_repository.dart';

class ProductController {
  final ProductRepository productRepository;

  ProductController({
    required this.productRepository
  });
  
  Future<ApiResponse<List<Product>>> fetchAllProducts(/*String token*/) async {
    return productRepository.fetchAllProducts(/*token*/);
  }
  
  // Future<ApiResponse<List<Product>>> fetchProductDetails(String token) async {
  //   return productRepository.fetchProductDetails(token);
  // }
}
