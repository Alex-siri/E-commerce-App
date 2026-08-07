import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../../../products/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController(); // acts as email
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  
  // This boolean toggles the UI between Login and Sign Up mode
  bool _isLoginMode = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF121212),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthAuthenticated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_isLoginMode ? 'Login Successful!' : 'Account Created!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
                    );
                  }
                },
                builder: (context, state) {
                  return Card(
                    color: const Color(0xFF1E1E1E), // Dark card surface
                    elevation: 20, 
                    shadowColor: Colors.black87,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), 
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              _isLoginMode ? Icons.storefront_rounded : Icons.person_add_alt_1_rounded, 
                              key: ValueKey<bool>(_isLoginMode),
                              size: 72, 
                              color: Colors.redAccent // Red
                            ),
                          ),
                          const SizedBox(height: 24),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              _isLoginMode ? 'Welcome Back 👋' : 'Create Account ✨',
                              key: ValueKey<bool>(_isLoginMode),
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 12),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              _isLoginMode ? 'Sign in to access your Fake Store' : 'Join the Fake Store today',
                              key: ValueKey<bool>(_isLoginMode),
                              style: const TextStyle(color: Colors.white70, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Username / Email Field
                          TextField(
                            controller: _usernameController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              labelStyle: const TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: const Color(0xFF2A2A2A),
                              prefixIcon: const Icon(Icons.email_outlined, color: Colors.redAccent),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Additional Fields for Sign Up Mode only
                          if (!_isLoginMode) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _firstNameController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'First Name',
                                      labelStyle: const TextStyle(color: Colors.white54),
                                      filled: true,
                                      fillColor: const Color(0xFF2A2A2A),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    controller: _lastNameController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Last Name',
                                      labelStyle: const TextStyle(color: Colors.white54),
                                      filled: true,
                                      fillColor: const Color(0xFF2A2A2A),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _addressController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Address',
                                labelStyle: const TextStyle(color: Colors.white54),
                                filled: true,
                                fillColor: const Color(0xFF2A2A2A),
                                prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.redAccent),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _postalCodeController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Postal Code',
                                labelStyle: const TextStyle(color: Colors.white54),
                                filled: true,
                                fillColor: const Color(0xFF2A2A2A),
                                prefixIcon: const Icon(Icons.markunread_mailbox_outlined, color: Colors.redAccent),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                labelStyle: const TextStyle(color: Colors.white54),
                                filled: true,
                                fillColor: const Color(0xFF2A2A2A),
                                prefixIcon: const Icon(Icons.phone_outlined, color: Colors.redAccent),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          
                          // Password Field
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: const Color(0xFF2A2A2A),
                              prefixIcon: const Icon(Icons.lock_outline, color: Colors.redAccent),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Main Action Button
                          Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.redAccent, // Solid Red
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.redAccent.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: state is AuthLoading ? null : () {
                                final username = _usernameController.text.trim().toLowerCase();
                                final password = _passwordController.text.trim();
                                
                                // Basic validations
                                if (username.isEmpty || password.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email and Password cannot be empty'), backgroundColor: Colors.redAccent));
                                  return;
                                }

                                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                if (!emailRegex.hasMatch(username)) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid email address'), backgroundColor: Colors.redAccent));
                                  return;
                                }
                                
                                if (!_isLoginMode) {
                                  final firstName = _firstNameController.text.trim();
                                  final lastName = _lastNameController.text.trim();
                                  final address = _addressController.text.trim();
                                  final postalCode = _postalCodeController.text.trim();
                                  final phone = _phoneController.text.trim();
                                  
                                  if (firstName.isEmpty || lastName.isEmpty || address.isEmpty || postalCode.isEmpty || phone.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All fields must be filled to sign up'), backgroundColor: Colors.redAccent));
                                    return;
                                  }

                                  final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
                                  if (!phoneRegex.hasMatch(phone)) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid phone number'), backgroundColor: Colors.redAccent));
                                    return;
                                  }

                                  context.read<AuthCubit>().signUp(
                                    username, 
                                    password,
                                    firstName: firstName,
                                    lastName: lastName,
                                    address: address,
                                    postalCode: postalCode,
                                    phoneNumber: phone,
                                  );
                                } else {
                                  context.read<AuthCubit>().login(username, password);
                                }
                              },
                              child: state is AuthLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                      _isLoginMode ? 'LOG IN' : 'SIGN UP',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2),
                                    ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          // The Toggle Button
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLoginMode = !_isLoginMode;
                              });
                            },
                            child: Text(
                              _isLoginMode 
                                ? "Don't have an account? Sign Up" 
                                : "Already have an account? Login",
                              style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}