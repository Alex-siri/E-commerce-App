import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/products/domain/entities/product.dart';

class FavoriteState {
  final List<Product> items;
  FavoriteState(this.items);
}

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteState([]));

  void toggleFavorite(Product product) {
    final bool exists = state.items.any((p) => p.id == product.id);
    if (exists) {
      emit(FavoriteState(state.items.where((p) => p.id != product.id).toList()));
    } else {
      emit(FavoriteState(List.from(state.items)..add(product)));
    }
  }

  bool isFavorite(int productId) {
    return state.items.any((p) => p.id == productId);
  }
}
