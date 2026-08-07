import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_cubit.dart';
import '../../../../features/products/presentation/pages/home_page.dart';

class PaymentPage extends StatefulWidget {
  final String totalAmount;

  const PaymentPage({super.key, required this.totalAmount});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isProcessing = false;

  void _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate network delay for payment processing
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Clear the cart securely (We will need to add clearCart to CartCubit)
    context.read<CartCubit>().clearCart();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment Successful! Thank you for your order.'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Instead of forcing clear cart right away (if not implemented), we'll navigate back home.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: const Text('Checkout', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E), // Darker surface
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(color: Colors.redAccent.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Amount to Pay', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    widget.totalAmount,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            
            // Fake Credit Card UI block
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.credit_card, color: Colors.redAccent, size: 28),
                      const SizedBox(width: 12),
                      const Text('Credit / Debit Card', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                      const Spacer(),
                      const Icon(Icons.check_circle, color: Colors.redAccent),
                    ],
                  ),
                  const Divider(height: 32, color: Colors.white10),
                  const TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      labelStyle: TextStyle(color: Colors.white54),
                      hintText: '0000 0000 0000 0000',
                      hintStyle: TextStyle(color: Colors.white24),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Expiry Date', labelStyle: TextStyle(color: Colors.white54), hintText: 'MM/YY', hintStyle: TextStyle(color: Colors.white24), border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'CVV', labelStyle: TextStyle(color: Colors.white54), hintText: '123', hintStyle: TextStyle(color: Colors.white24), border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                          ),
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Cardholder Name',
                      labelStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 48),
            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent, // Gold button
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isProcessing ? null : _processPayment,
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.black87)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock, color: Colors.black87, size: 20),
                          const SizedBox(width: 12),
                          Text('Pay ${widget.totalAmount}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
