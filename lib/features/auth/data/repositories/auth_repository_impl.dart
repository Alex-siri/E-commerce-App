import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import 'dart:convert';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<User> login(String email, String password) async {
    try {
      // Check local storage first for signed up users
      final localUserJson = sharedPreferences.getString('user_$email');
      if (localUserJson != null) {
        final localData = jsonDecode(localUserJson);
        if (localData['password'] == password) {
            await sharedPreferences.setString('auth_token', 'local_token_for_$email');
            return User(
              id: localData['id'] ?? 200, 
              email: email, 
              username: email.split('@')[0],
              firstName: localData['firstName'],
              lastName: localData['lastName'],
              address: localData['address'],
              postalCode: localData['postalCode'],
              phoneNumber: localData['phoneNumber'],
              profilePic: localData['profilePic'],
            );
        } else {
            throw Exception('Invalid password for locally registered user.');
        }
      }

      // 1. Get the token from the FakeStore API (fallback)
      final token = await remoteDataSource.login(email, password);
      
      // 2. Save the token locally so the user stays logged in
      await sharedPreferences.setString('auth_token', token);

      // 3. FakeStoreAPI doesn't return user details on login, only a token.
      return User(id: 1, email: email, username: email.split('@')[0]);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Adding Signup method (note: you should also add this to AuthRepository abstract class)
  @override
  Future<User> signUp(
    String email, 
    String password, {
    String? firstName,
    String? lastName,
    String? address,
    String? postalCode,
    String? phoneNumber,
    String? profilePic,
  }) async {
    try {
      final userMap = {
        'id': DateTime.now().millisecondsSinceEpoch % 1000,
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'address': address,
        'postalCode': postalCode,
        'phoneNumber': phoneNumber,
        'profilePic': profilePic,
      };
      
      await sharedPreferences.setString('user_$email', jsonEncode(userMap));
      await sharedPreferences.setString('auth_token', 'local_token_for_$email');
      
      return User(
        id: userMap['id'] as int, 
        email: email, 
        username: email.split('@')[0],
        firstName: firstName,
        lastName: lastName,
        address: address,
        postalCode: postalCode,
        phoneNumber: phoneNumber,
        profilePic: profilePic,
      );
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  @override
  Future<User> updateProfilePic(String email, String profilePicPath) async {
    final localUserJson = sharedPreferences.getString('user_$email');
    if (localUserJson == null) throw Exception('User not found.');

    final localData = jsonDecode(localUserJson);
    localData['profilePic'] = profilePicPath;
    await sharedPreferences.setString('user_$email', jsonEncode(localData));

    return User(
      id: localData['id'] ?? 200, 
      email: email, 
      username: email.split('@')[0],
      firstName: localData['firstName'],
      lastName: localData['lastName'],
      address: localData['address'],
      postalCode: localData['postalCode'],
      phoneNumber: localData['phoneNumber'],
      profilePic: profilePicPath,
    );
  }

  @override
  Future<User> updateProfile(User updatedUser) async {
    final email = updatedUser.email;
    final localUserJson = sharedPreferences.getString('user_$email');
    if (localUserJson == null) throw Exception('User not found in local storage.');

    final localData = jsonDecode(localUserJson);
    localData['firstName'] = updatedUser.firstName;
    localData['lastName'] = updatedUser.lastName;
    localData['address'] = updatedUser.address;
    localData['postalCode'] = updatedUser.postalCode;
    localData['phoneNumber'] = updatedUser.phoneNumber;
    
    await sharedPreferences.setString('user_$email', jsonEncode(localData));

    return updatedUser;
  }
}