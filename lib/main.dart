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
import 'features/auth/domain/usecases/signup_user.dart';
import 'features/auth/domain/usecases/update_profile_pic.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';

// Import the missing Product files
import 'features/products/data/datasources/product_remote_data_source.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/presentation/bloc/product_cubit.dart';
import 'features/products/presentation/bloc/currency_cubit.dart';

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
  final signUpUserUseCase = SignUpUser(authRepository);
  final updateProfilePicUseCase = UpdateProfilePic(authRepository);

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
    MyApp(
      loginUser: loginUserUseCase,
      signUpUser: signUpUserUseCase,
      updateProfilePic: updateProfilePicUseCase,
      getAllProducts: getAllProductsUseCase,
    ),
  );
}

class MyApp extends StatelessWidget {
  final LoginUser loginUser;
  final SignUpUser signUpUser;
  final UpdateProfilePic updateProfilePic;
  final GetAllProducts getAllProducts;

  const MyApp({
    super.key,
    required this.loginUser,
    required this.signUpUser,
    required this.updateProfilePic,
    required this.getAllProducts,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(
          loginUser: loginUser, 
          signUpUser: signUpUser, 
          updateProfilePic: updateProfilePic
        )),
        BlocProvider(
          create: (context) => ProductCubit(getAllProducts: getAllProducts),
        ),
        BlocProvider(create: (context) => CurrencyCubit()),
        // ADDED THE CART CUBIT HERE!
        BlocProvider(create: (context) => CartCubit()),
      ],
      child: MaterialApp(
        title: 'Merkato shopping app',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF121212),
          primaryColor: const Color(0xFFFFD700),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFFD700),
            secondary: Color(0xFFFFD700),
            surface: Color(0xFF1E1E1E),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A1A1A),
            foregroundColor: Color(0xFFFFD700), // Gold text on AppBar
          ),
        ),
        home: const LoginPage(),
      ),
    );
  }
}





// Username: mor_2314
// Password: 83r5^_