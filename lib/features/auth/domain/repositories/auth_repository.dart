import '../entities/user.dart';

abstract class AuthRepository {
  // This method will handle sending the email/password to the API and returning the User
  Future<User> login(String email, String password);
}