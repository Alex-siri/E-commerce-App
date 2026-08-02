import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<User> login(String email, String password) async {
    try {
      // 1. Get the token from the FakeStore API
      final token = await remoteDataSource.login(email, password);
      
      // 2. Save the token locally so the user stays logged in
      await sharedPreferences.setString('auth_token', token);

      // 3. FakeStoreAPI doesn't return user details on login, only a token.
      // We would normally make a second request to `/users/{id}` to get the profile.
      // For this step, we will mock the returned User entity so our UseCase succeeds.
      return User(id: 1, email: email, username: email.split('@')[0]);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}