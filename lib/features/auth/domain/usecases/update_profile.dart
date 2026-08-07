import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class UpdateProfile {
  final AuthRepository repository;

  UpdateProfile(this.repository);

  Future<User> call(User updatedUser) {
    return repository.updateProfile(updatedUser);
  }
}
