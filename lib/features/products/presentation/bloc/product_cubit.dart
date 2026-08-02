import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_products.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetAllProducts getAllProducts;

  ProductCubit({required this.getAllProducts}) : super(ProductInitial());

  // This function will be called when the Home Screen loads
  Future<void> fetchProducts() async {
    emit(ProductLoading()); // Show the loading spinner

    try {
      // Fetch the products from the API
      final products = await getAllProducts();
      
      // If successful, broadcast the list of products to the UI
      emit(ProductLoaded(products));
    } catch (e) {
      // If something goes wrong, broadcast the error
      emit(ProductError(e.toString()));
    }
  }
}