import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// 1. The default state when the app first opens
class AuthInitial extends AuthState {}

// 2. The state when we are waiting for the FakeStore API to respond
class AuthLoading extends AuthState {}

// 3. The state when login is successful (holds the User data)
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

// 4. The state when login fails (holds the error message)
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}