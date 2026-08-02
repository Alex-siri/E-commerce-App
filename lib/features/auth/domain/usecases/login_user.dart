import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  // We pass the required email and password to the repository
  Future<User> call(String email, String password) async {
    return await repository.login(email, password);
  }
}