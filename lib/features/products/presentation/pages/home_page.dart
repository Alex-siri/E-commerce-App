import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_details_page.dart';

// Product Imports
import '../bloc/product_cubit.dart';
import '../bloc/product_state.dart';
import '../bloc/currency_cubit.dart';

// Cart Imports
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../cart/presentation/pages/cart_page.dart';

// Profile Imports
import '../../../../features/auth/presentation/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          height: 40,
          margin: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E), // Darker shade than black
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.5), width: 1.5),
          ),
          child: const TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: TextStyle(fontSize: 14, color: Colors.white54),
              prefixIcon: Icon(Icons.search, color: Color(0xFFFFD700)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          BlocBuilder<CurrencyCubit, AppCurrency>(
            builder: (context, currency) {
              return TextButton.icon(
                onPressed: () {
                  context.read<CurrencyCubit>().toggleCurrency();
                },
                icon: const Icon(Icons.language, size: 18, color: Color(0xFFFFD700)),
                label: Text(
                  currency == AppCurrency.usd ? 'USD' : 'ETB',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFD700)),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartPage(),
                        ),
                      );
                    },
                  ),
                  if (state.items.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${state.items.length}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            height: 50,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white10)),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryItem('Choice', isGold: true),
                _buildCategoryItem('SuperDeals'),
                _buildCategoryItem('Merkato bussiness'),
                _buildCategoryItem('Automotive'),
                _buildCategoryItem('Appliances'),
                _buildCategoryItem('Women\'s Clothing'),
                _buildCategoryItem('Men\'s Clothing'),
                _buildCategoryItem('Furniture'),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading || state is ProductInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          } else if (state is ProductLoaded) {
            final products = state.products;

            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                
                // Wrap the Card in a GestureDetector to trigger navigation
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(product: product),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Center(
                              // Wrap the Image in a Hero widget for the animation
                              child: Hero(
                                tag: 'product_image_${product.id}',
                                child: Image.network(
                                  product.image,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BlocBuilder<CurrencyCubit, AppCurrency>(
                                builder: (context, currency) {
                                  return Text(
                                    context.read<CurrencyCubit>().formatPrice(product.price),
                                    style: const TextStyle(
                                      color: Color(0xFFFFD700), // Gold
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_shopping_cart,
                                  color: Color(0xFFFFD700), // Gold
                                ),
                                onPressed: () {
                                  context.read<CartCubit>().addToCart(product);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Added to Cart!'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCategoryItem(String title, {bool isGold = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isGold ? FontWeight.bold : FontWeight.w500,
            color: isGold ? const Color(0xFFFFD700) : Colors.white70,
          ),
        ),
      ),
    );
  }
}