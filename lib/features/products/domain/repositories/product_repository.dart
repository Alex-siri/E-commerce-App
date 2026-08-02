import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  // We can add more methods here later, like getProductById(int id)
}