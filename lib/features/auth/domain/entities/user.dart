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

  User copyWith({
    int? id,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    String? address,
    String? postalCode,
    String? phoneNumber,
    String? profilePic,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      postalCode: postalCode ?? this.postalCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePic: profilePic ?? this.profilePic,
    );
  }
}