import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpUser {
  final AuthRepository repository;

  SignUpUser(this.repository);

  // The 'call' method allows us to call the class like a function: signUpUser(...)
  Future<User> call(
    String email, 
    String password, {
    String? firstName,
    String? lastName,
    String? address,
    String? postalCode,
    String? phoneNumber,
    String? profilePic,
  }) {
    return repository.signUp(
      email, 
      password,
      firstName: firstName,
      lastName: lastName,
      address: address,
      postalCode: postalCode,
      phoneNumber: phoneNumber,
      profilePic: profilePic,
    );
  }
}
