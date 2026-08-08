import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/order.dart';

class OrderState {
  final List<OrderEntity> orders;
  const OrderState(this.orders);
}

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(const OrderState([]));

  void addOrder(OrderEntity order) {
    emit(OrderState([order, ...state.orders]));
  }
}
