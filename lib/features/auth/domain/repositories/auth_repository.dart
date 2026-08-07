import '../entities/user.dart';

abstract class AuthRepository {
  // This method will handle sending the email/password to the API and returning the User
  Future<User> login(String email, String password);
  
  // Sign up a new user locally
  Future<User> signUp(
    String email, 
    String password, {
    String? firstName,
    String? lastName,
    String? address,
    String? postalCode,
    String? phoneNumber,
    String? profilePic,
  });

  // Update profile picture
  Future<User> updateProfilePic(String email, String profilePicPath);
  Future<User> updateProfile(User updatedUser);
}