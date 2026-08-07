import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/signup_user.dart';
import '../../domain/usecases/update_profile_pic.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/entities/user.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  // We bring in our Use Cases from the Domain layer
  final LoginUser loginUser;
  final SignUpUser signUpUser;
  final UpdateProfilePic updateProfilePic;
  final UpdateProfile updateProfile;

  // We start the Cubit with the 'AuthInitial' state
  AuthCubit({
    required this.loginUser, 
    required this.signUpUser, 
    required this.updateProfilePic,
    required this.updateProfile,
  }) : super(AuthInitial());

  // This is the function our UI will call when the login button is pressed
  Future<void> login(String email, String password) async {
    // Tell the UI to show a loading spinner
    emit(AuthLoading());

    try {
      // Execute the Use Case (which talks to the Repository, which talks to the API)
      final user = await loginUser(email, password);
      
      // If it succeeds, tell the UI we are authenticated!
      emit(AuthAuthenticated(user));
   } catch (e) {
      // We are replacing our custom message with the actual system error
      emit(AuthError(e.toString()));
    }
  }

  // The Sign Up Method
  Future<void> signUp(
    String email, 
    String password, {
    String? firstName,
    String? lastName,
    String? address,
    String? postalCode,
    String? phoneNumber,
    String? profilePic,
  }) async {
    emit(AuthLoading()); // Triggers the loading spinner on your UI
    
    try {
      // Execute the genuine Use Case
      final user = await signUpUser(
        email, 
        password,
        firstName: firstName,
        lastName: lastName,
        address: address,
        postalCode: postalCode,
        phoneNumber: phoneNumber,
        profilePic: profilePic,
      );
      
      emit(AuthAuthenticated(user)); 
    } catch (e) {
      emit(AuthError('Failed to create account. Please try again.'));
    }
  }

  // 2. The Logout Method
  void logout() {
    // Reset the state back to the initial starting point
    emit(AuthInitial()); 
  }

  // Update Profile Picture
  Future<void> updateProfilePicture(String imagePath) async {
    if (state is AuthAuthenticated) {
      try {
        final currentUser = (state as AuthAuthenticated).user;
        final updatedUser = await updateProfilePic(currentUser.email, imagePath);
        emit(AuthAuthenticated(updatedUser));
      } catch (e) {
        // Just silently fail or show error
      }
    }
  }

  Future<void> updateProfileDetails(User updatedUser) async {
    try {
      final user = await updateProfile(updatedUser);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}