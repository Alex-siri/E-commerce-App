import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_state.dart';
import '../../domain/entities/cart_item.dart';
import '../../../products/domain/entities/product.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addToCart(Product product) {
    // 1. Make a copy of the current cart items
    final currentItems = List<CartItem>.from(state.items);
    
    // 2. Check if the user already added this exact product before
    final existingIndex = currentItems.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      // 3a. If it's already in the cart, just increase the quantity by 1
      currentItems[existingIndex].quantity += 1;
    } else {
      // 3b. If it's brand new, add it to the list
      currentItems.add(CartItem(product: product));
    }

    // 4. Emit the updated list to update the UI
    emit(CartState(items: currentItems));
  }

  void removeFromCart(int productId) {
    final currentItems = List<CartItem>.from(state.items);
    
    // Find the item and remove it completely
    currentItems.removeWhere((item) => item.product.id == productId);
    
    emit(CartState(items: currentItems));
  }
}



