import 'package:flutter_bloc/flutter_bloc.dart';

enum AppCurrency { usd, etb }

class CurrencyCubit extends Cubit<AppCurrency> {
  CurrencyCubit() : super(AppCurrency.usd);

  void toggleCurrency() {
    if (state == AppCurrency.usd) {
      emit(AppCurrency.etb);
    } else {
      emit(AppCurrency.usd);
    }
  }

  void setCurrency(AppCurrency currency) {
    emit(currency);
  }

  // Helper method to format price based on the selected currency
  String formatPrice(double priceInUsd) {
    if (state == AppCurrency.usd) {
      return '\$${priceInUsd.toStringAsFixed(2)}';
    } else {
      // Multiply by 162 for Ethiopian Birr
      double priceInEtb = priceInUsd * 162.0;
      return 'Br ${priceInEtb.toStringAsFixed(2)}';
    }
  }
}
