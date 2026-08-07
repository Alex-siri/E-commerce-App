import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Ensure these imports match your actual folder structure
import '../bloc/cart_cubit.dart';
import '../bloc/cart_state.dart';
import 'payment_page.dart';
import '../../../products/presentation/bloc/currency_cubit.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          // 1. Handle Empty Cart
          if (state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.white54),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white54),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: Colors.black87,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Continue Shopping', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          }

          // 2. Display Cart Items
          return BlocBuilder<CurrencyCubit, AppCurrency>(
            builder: (context, currencyState) {
              final currencyCubit = context.read<CurrencyCubit>();
              return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    
                    return Card(
                      color: const Color(0xFF1E1E1E), // Dark surface
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: const Color(0xFFFFD700).withOpacity(0.2)),
                      ),
                     child: ListTile(
                        leading: Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.all(4),
                          child: Image.network(
                            item.product.image, // Updated to access the nested product
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain,
                          ),
                        ),
                        title: Text(
                          item.product.title, // Updated to access the nested product
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          currencyCubit.formatPrice(item.product.price),
                          style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                          onPressed: () {
                            context.read<CartCubit>().removeFromCart(item.product.id);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // 3. Checkout Bottom Bar
              // 3. Checkout Bottom Bar
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
                      ),
                      // 1. DYNAMIC CALCULATION: This adds up the prices of all items in the cart
                      Text(
                        currencyCubit.formatPrice(
                          state.items.fold(0.0, (total, item) => total + (item.product.price * item.quantity)),
                        ), 
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFFD700)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          backgroundColor: const Color(0xFFFFD700),
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          // Handle checkout logic
                          final totalValue = currencyCubit.formatPrice(
                            state.items.fold(0.0, (total, item) => total + (item.product.price * item.quantity)),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(totalAmount: totalValue),
                            ),
                          );
                        },
                        child: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ); // Closes CurrencyCubit BlocBuilder
    },
  ),
);
  }
}