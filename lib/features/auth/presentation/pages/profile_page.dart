import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import 'login_page.dart';
import 'edit_profile_page.dart';
import '../../../../features/orders/presentation/pages/order_history_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            // User logged out
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            final user = state.user;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            context.read<AuthCubit>().updateProfilePicture(pickedFile.path);
                          }
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.redAccent.withOpacity(0.2),
                              backgroundImage: user.profilePic != null && user.profilePic!.isNotEmpty
                                  ? (kIsWeb ? NetworkImage(user.profilePic!) : FileImage(File(user.profilePic!))) as ImageProvider
                                  : null,
                              child: user.profilePic == null || user.profilePic!.isEmpty
                                  ? const Icon(Icons.person, size: 60, color: Colors.redAccent)
                                  : null,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(Icons.edit, size: 20, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      (user.firstName != null && user.firstName!.isNotEmpty) 
                          ? '${user.firstName} ${user.lastName ?? ''}'.trim().toUpperCase()
                          : user.username.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 48),
                    _buildInfoCard(Icons.email_outlined, 'Email', user.email),
                    const SizedBox(height: 16),
                    _buildInfoCard(Icons.badge_outlined, 'Username', user.username),
                    const SizedBox(height: 16),
                    if (user.firstName != null && user.firstName!.isNotEmpty) ...[
                      _buildInfoCard(Icons.person_outline, 'Full Name', '${user.firstName} ${user.lastName ?? ''}'),
                      const SizedBox(height: 16),
                    ],
                    if (user.address != null && user.address!.isNotEmpty) ...[
                      _buildInfoCard(Icons.location_city_outlined, 'Address', user.address!),
                      const SizedBox(height: 16),
                    ],
                    if (user.postalCode != null && user.postalCode!.isNotEmpty) ...[
                      _buildInfoCard(Icons.local_post_office_outlined, 'Postal Code', user.postalCode!),
                      const SizedBox(height: 16),
                    ],
                    if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) ...[
                      _buildInfoCard(Icons.phone_outlined, 'Phone Number', user.phoneNumber!),
                      const SizedBox(height: 16),
                    ],
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white10,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const OrderHistoryPage()),
                            );
                          },
                          icon: const Icon(Icons.receipt_long_outlined),
                          label: const Text(
                            'Order History',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditProfilePage(user: user)),
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text(
                            'Edit Profile',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E1E1E),
                            foregroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(color: Colors.redAccent, width: 1.5),
                            ),
                          ),
                          onPressed: () {
                            context.read<AuthCubit>().logout();
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text(
                            'Log out',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
        },
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black45.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.redAccent, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
