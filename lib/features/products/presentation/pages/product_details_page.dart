import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../domain/entities/product.dart'; // Adjust this import path if your Product entity is elsewhere!
import '../bloc/currency_cubit.dart';
import '../../../favorites/presentation/bloc/favorite_cubit.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          BlocBuilder<FavoriteCubit, FavoriteState>(
            builder: (context, favState) {
              final isFav = favState.items.any((p) => p.id == product.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  context.read<FavoriteCubit>().toggleFavorite(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isFav ? 'Removed from Favorites' : 'Added to Favorites'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF121212),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The Hero Widget connects this image to the one on the Home Screen!
            Hero(
              tag: 'product_image_${product.id}',
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Image.network(product.image, fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      BlocBuilder<CurrencyCubit, AppCurrency>(
                        builder: (context, currency) {
                          return Text(
                            context.read<CurrencyCubit>().formatPrice(product.price),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.white70),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<CartCubit>().addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to Cart!'),
                            duration: Duration(seconds: 1),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart_checkout),
                      label: const Text('Add to Cart', style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}