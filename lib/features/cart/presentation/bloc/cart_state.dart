import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  // The cart starts completely empty by default
  const CartState({this.items = const []});

  // A handy getter that automatically calculates the total price of everything in the cart
  double get totalPrice {
    return items.fold(0, (total, currentItem) {
      return total + (currentItem.product.price * currentItem.quantity);
    });
  }

  @override
  List<Object> get props => [items]; // This tells Bloc when to redraw the UI
}