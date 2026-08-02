import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetAllProducts {
  final ProductRepository repository;

  GetAllProducts(this.repository);

  // The 'call' method allows us to call the class like a function: getAllProducts()
  Future<List<Product>> call() async {
    return await repository.getProducts();
  }
}