import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_user.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  // We bring in our Use Case from the Domain layer
  final LoginUser loginUser;

  // We start the Cubit with the 'AuthInitial' state
  AuthCubit({required this.loginUser}) : super(AuthInitial());

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
}