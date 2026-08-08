import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'product_details_page.dart';

// Product Imports
import '../bloc/product_cubit.dart';
import '../bloc/product_state.dart';
import '../bloc/currency_cubit.dart';

// Cart Imports
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../cart/presentation/pages/cart_page.dart';

// Favorites Imports
import '../../../favorites/presentation/bloc/favorite_cubit.dart';
import '../../../favorites/presentation/pages/favorites_page.dart';

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
            border: Border.all(color: Colors.redAccent.withOpacity(0.5), width: 1.5),
          ),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              context.read<ProductCubit>().searchProducts(value);
            },
            decoration: const InputDecoration(
              hintText: 'Search products...',
              hintStyle: TextStyle(fontSize: 14, color: Colors.white54),
              prefixIcon: Icon(Icons.search, color: Colors.redAccent),
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
                icon: const Icon(Icons.language, size: 18, color: Colors.redAccent),
                label: Text(
                  currency == AppCurrency.usd ? 'USD' : 'ETB',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
                ),
              );
            },
          ),
          BlocBuilder<FavoriteCubit, FavoriteState>(
            builder: (context, favState) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.redAccent),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FavoritesPage()),
                      );
                    },
                  ),
                  if (favState.items.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${favState.items.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            }
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
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
                          color: Colors.redAccent,
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
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                final currentCategory = context.read<ProductCubit>().currentCategory;
                return ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildCategoryItem('Choice', currentCategory),
                    _buildCategoryItem('SuperDeals', currentCategory),
                    _buildCategoryItem('Merkato bussiness', currentCategory),
                    _buildCategoryItem('Automotive', currentCategory),
                    _buildCategoryItem('Appliances', currentCategory),
                    _buildCategoryItem('Women\'s Clothing', currentCategory),
                    _buildCategoryItem('Men\'s Clothing', currentCategory),
                  ],
                );
              }
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

            return Column(
              children: [
                const SizedBox(height: 16),
                _buildCarousel(),
                const SizedBox(height: 8),
                Expanded(
                  child: GridView.builder(
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
                            child: Stack(
                              children: [
                                Center(
                                  // Wrap the Image in a Hero widget for the animation
                                  child: Hero(
                                    tag: 'product_image_${product.id}',
                                    child: Image.network(
                                      product.image,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -8,
                                  right: -8,
                                  child: BlocBuilder<FavoriteCubit, FavoriteState>(
                                    builder: (context, favState) {
                                      final isFav = context.read<FavoriteCubit>().isFavorite(product.id);
                                      return IconButton(
                                        icon: Icon(
                                          isFav ? Icons.favorite : Icons.favorite_border, 
                                          color: Colors.redAccent,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          context.read<FavoriteCubit>().toggleFavorite(product);
                                        },
                                      );
                                    }
                                  ),
                                ),
                              ],
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
                                      color: Colors.redAccent, // Gold
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.redAccent, // Gold
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
            ),
           ),
          ],
         );
        }
        return const SizedBox.shrink();
      },
     ),
    );
  }

  Widget _buildCarousel() {
    final List<Map<String, String>> dummyBanners = [
      {
        'image': 'https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=1000&auto=format&fit=crop',
        'tag': 'NEW SEASON',
        'title': 'Trending Fashion\nEvery Week',
      },
      {
        'image': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?q=80&w=1000&auto=format&fit=crop',
        'tag': 'TECH DEALS',
        'title': 'Upgrade Your\nWorkspace',
      },
      {
        'image': 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=1000&auto=format&fit=crop',
        'tag': 'MEMBER EXCLUSIVE',
        'title': 'Huge Discounts\non Bags',
      },
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 180.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        enlargeCenterPage: true,
        viewportFraction: 0.9,
      ),
      items: dummyBanners.map((banner) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(banner['image']!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(banner['tag']!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      banner['title']!,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildCategoryItem(String title, String activeCategory) {
    bool isRed = title == activeCategory;
    return GestureDetector(
      onTap: () {
        context.read<ProductCubit>().setCategory(title);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 24),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isRed ? FontWeight.bold : FontWeight.w500,
              color: isRed ? Colors.redAccent : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}