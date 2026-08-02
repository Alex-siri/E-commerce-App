import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

// Notice how it implements the abstract class from our Domain layer!
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts() async {
    try {
      // We call the data source which returns a List of ProductModels
      final remoteProducts = await remoteDataSource.getAllProducts();
      
      // Because ProductModel extends Product, we can safely return it here
      return remoteProducts;
    } catch (e) {
      // In a real app, we would return a custom Failure class here, but we will throw an exception for now.
      throw Exception('Failed to fetch products: $e');
    }
  }
}