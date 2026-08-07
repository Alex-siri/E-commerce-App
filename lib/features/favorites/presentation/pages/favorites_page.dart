import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/favorite_cubit.dart';
import '../../../../features/products/presentation/bloc/currency_cubit.dart';
import '../../../../features/products/presentation/pages/product_details_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.white54),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet!',
                    style: TextStyle(fontSize: 20, color: Colors.white54),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: state.items.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final product = state.items[index];
              return Card(
                color: const Color(0xFF1E1E1E),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.redAccent.withOpacity(0.2)),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(product: product),
                      ),
                    );
                  },
                  leading: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(4),
                    child: Image.network(
                      product.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                  title: Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: BlocBuilder<CurrencyCubit, AppCurrency>(
                    builder: (context, currency) {
                      return Text(
                        context.read<CurrencyCubit>().formatPrice(product.price),
                        style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.redAccent),
                    onPressed: () {
                      context.read<FavoriteCubit>().toggleFavorite(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Removed from favorites'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
