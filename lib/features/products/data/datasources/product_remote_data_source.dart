import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    // We hit the FakeStoreAPI endpoint for all products
    final response = await client.get(
      Uri.parse('https://fakestoreapi.com/products'),
    );

    if (response.statusCode == 200) {
      // The response is a JSON string. We decode it into a List of dynamic objects.
      final List<dynamic> jsonList = json.decode(response.body);
      
      // We map over that list and convert each JSON object into our ProductModel
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      // For now, we throw a simple exception if it fails. We'll handle errors better later!
      throw Exception('Failed to load products');
    }
  }
}
