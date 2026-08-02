import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String username;
  
  // We can add a name class if we want to parse the nested firstname/lastname
  // from the FakeStore API, but for now we'll stick to the basics.

  const User({
    required this.id,
    required this.email,
    required this.username,
  });

  @override
  List<Object?> get props => [id, email, username];
}