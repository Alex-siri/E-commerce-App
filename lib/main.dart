import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Import our feature files
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() async {
  // 1. Ensure Flutter is fully initialized before we run asynchronous code (like SharedPreferences)
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

  // 4. Start the app and pass our configured Use Case into it
  runApp(MyApp(loginUser: loginUserUseCase));
}

class MyApp extends StatelessWidget {
  final LoginUser loginUser;

  const MyApp({super.key, required this.loginUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fake Store E-Commerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // 5. Use BlocProvider to give our LoginPage access to the AuthCubit
      home: BlocProvider(
        create: (context) => AuthCubit(loginUser: loginUser),
        child: const LoginPage(),
      ),
    );
  }
}