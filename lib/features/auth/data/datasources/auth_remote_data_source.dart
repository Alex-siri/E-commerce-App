import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class AuthRemoteDataSource {
  Future<String> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<String> login(String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('https://fakestoreapi.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        // We add .trim() to ensure no invisible spaces ruin the login!
        body: jsonEncode({
          'username': email.trim(),
          'password': password.trim(),
        }),
      );

     // Change this line to accept anything in the 200-299 success range
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['token'];
      } else {
        throw Exception('Server Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      // This catches any internet connection/CORS issues
      throw Exception('Network/System Error: $e');
    }
  }
}
