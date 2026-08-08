import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../../domain/entities/user.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _addressController;
  late TextEditingController _postalCodeController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _addressController = TextEditingController(text: widget.user.address);
    _postalCodeController = TextEditingController(text: widget.user.postalCode);
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final updatedUser = widget.user.copyWith(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      address: _addressController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
    );

    context.read<AuthCubit>().updateProfileDetails(updatedUser);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField('First Name', _firstNameController, Icons.person),
            const SizedBox(height: 16),
            _buildTextField('Last Name', _lastNameController, Icons.person_outline),
            const SizedBox(height: 16),
            _buildTextField('Address', _addressController, Icons.location_on),
            const SizedBox(height: 16),
            _buildTextField('Postal Code', _postalCodeController, Icons.markunread_mailbox),
            const SizedBox(height: 16),
            _buildTextField('Phone Number', _phoneController, Icons.phone, TextInputType.phone),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, [TextInputType inputType = TextInputType.text]) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        prefixIcon: Icon(icon, color: Colors.redAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
      ),
    );
  }
}
