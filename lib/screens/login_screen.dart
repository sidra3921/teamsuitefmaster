import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart'; // Import for fingerprint authentication
import 'dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // Controllers for username, password, and PIN fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication(); // Instance for fingerprint authentication

  Widget _buildTextField(
    BuildContext context,
    String hint, {
    bool obscureText = false,
    required TextEditingController controller,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Color.fromARGB(255, 242, 242, 242)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 242, 242, 242)),
          filled: true,
          fillColor: Colors.black.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) {
    if (_usernameController.text == 'Manager' &&
        _passwordController.text == 'FSDEMO123' &&
        _pinController.text == 'demo') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid credentials. Please try again.'),
        ),
      );
    }
  }

  Future<void> _authenticateWithFingerprint(BuildContext context) async {
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to log in',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      if (didAuthenticate) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Authentication failed. Please try again.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bd_login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_ts.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 20),

                // SIGN IN Text
                const Text(
                  'SIGN IN',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromARGB(255, 10, 175, 225),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 40),

                // Username Field
                _buildTextField(
                  context,
                  'Username',
                  controller: _usernameController,
                ),
                const SizedBox(height: 15),

                // Password Field
                _buildTextField(
                  context,
                  'Password',
                  obscureText: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 15),

                // PIN Field
                _buildTextField(
                  context,
                  'PIN',
                  obscureText: true,
                  controller: _pinController,
                ),
                const SizedBox(height: 30),

                // Login Button
                ElevatedButton(
                  onPressed: () => _login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 252, 252, 251),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Biometric Authentication Button
                IconButton(
                  icon: const Icon(
                    Icons.fingerprint,
                    size: 40,
                    color: Colors.lightBlue,
                  ),
                  onPressed: () => _authenticateWithFingerprint(context),
                ),
                const SizedBox(height: 10),

                // Forgot Password Button
                TextButton(
                  onPressed: () {
                    // Add forgot password logic here
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 19,
                      color: Color.fromARGB(255, 13, 120, 187),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}