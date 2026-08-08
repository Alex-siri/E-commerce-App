import 'package:equatable/equatable.dart';
import '../../../../features/cart/domain/entities/cart_item.dart';

class OrderEntity extends Equatable {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final String totalAmount;

  const OrderEntity({
    required this.id,
    required this.date,
    required this.items,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [id, date, items, totalAmount];
}
