import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? postalCode;
  final String? phoneNumber;
  final String? profilePic;

  const User({
    required this.id,
    required this.email,
    required this.username,
    this.firstName,
    this.lastName,
    this.address,
    this.postalCode,
    this.phoneNumber,
    this.profilePic,
  });

  @override
  List<Object?> get props => [id, email, username, firstName, lastName, address, postalCode, phoneNumber, profilePic];
}