import 'package:e_commerce_app/features/products/domain/usecases/get_all_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Import our feature files
import 'features/cart/presentation/bloc/cart_cubit.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';

// Import the missing Product files
import 'features/products/data/datasources/product_remote_data_source.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/presentation/bloc/product_cubit.dart';

void main() async {
  // 1. Ensure Flutter is fully initialized before we run asynchronous code
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize our external packages
  final sharedPreferences = await SharedPreferences.getInstance();
  final httpClient = http.Client();

  // 3. Wire up the Authentication "pipes" (Dependency Injection)
  final authRemoteDataSource = AuthRemoteDataSourceImpl(client: httpClient);

  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    sharedPreferences: sharedPreferences,
  );

  final loginUserUseCase = LoginUser(authRepository);

  // 4. Wire up the Product "pipes" (Dependency Injection)
  final productRemoteDataSource = ProductRemoteDataSourceImpl(
    client: httpClient,
  );
  final productRepository = ProductRepositoryImpl(
    remoteDataSource: productRemoteDataSource,
  );
  final getAllProductsUseCase = GetAllProducts(productRepository);

  // 5. Start the app and pass BOTH configured Use Cases into it
  runApp(
    MyApp(loginUser: loginUserUseCase, getAllProducts: getAllProductsUseCase),
  );
}

class MyApp extends StatelessWidget {
  final LoginUser loginUser;
  final GetAllProducts getAllProducts;

  const MyApp({
    super.key,
    required this.loginUser,
    required this.getAllProducts,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(loginUser: loginUser)),
        BlocProvider(
          create: (context) => ProductCubit(getAllProducts: getAllProducts),
        ),
        // ADDED THE CART CUBIT HERE!
        BlocProvider(create: (context) => CartCubit()),
      ],
      child: MaterialApp(
        title: 'Fake Store E-Commerce',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
