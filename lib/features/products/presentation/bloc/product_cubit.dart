import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_products.dart';
import 'product_state.dart';

import '../../domain/entities/product.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetAllProducts getAllProducts;
  
  List<Product> _allProducts = [];
  String _searchQuery = '';
  String _currentCategory = 'Choice'; // Default "All" equivalent

  ProductCubit({required this.getAllProducts}) : super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());

    try {
      final products = await getAllProducts();
      _allProducts = products;
      _applyFilters();
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void searchProducts(String query) {
    _searchQuery = query.trim().toLowerCase();
    _applyFilters();
  }

  void setCategory(String category) {
    _currentCategory = category;
    _applyFilters();
  }
  
  String get currentCategory => _currentCategory;

  void _applyFilters() {
    List<Product> filtered = List.from(_allProducts);

    if (_currentCategory != 'Choice') {
      filtered = filtered.where((p) {
        if (_currentCategory == "Women\'s Clothing") return p.category == "women's clothing";
        if (_currentCategory == "Men\'s Clothing") return p.category == "men's clothing";
        if (_currentCategory == "Appliances") return p.category == "electronics";
        if (_currentCategory == "Merkato bussiness") return p.category == "jewelery";
        return true; 
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) => p.title.toLowerCase().contains(_searchQuery)).toList();
    }

    emit(ProductLoaded(filtered));
  }
}