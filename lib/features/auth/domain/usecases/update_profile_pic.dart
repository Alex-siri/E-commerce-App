import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class UpdateProfilePic {
  final AuthRepository repository;

  UpdateProfilePic(this.repository);

  Future<User> call(String email, String profilePicPath) {
    return repository.updateProfilePic(email, profilePicPath);
  }
}
