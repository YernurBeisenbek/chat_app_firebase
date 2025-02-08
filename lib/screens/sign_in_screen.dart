import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'chat_list_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false; // To track the loading state

  Future<void> _handleSignIn(BuildContext context) async {
    setState(() {
      _isLoading = true; // Show loading indicator
      
    });

    try {
      final User? user = await _authService.signInWithGoogle();
      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ChatListScreen()),
        );
      } else {
        _showSnackBar(context, 'Sign-in failed. Please try again.');
      }
    } catch (error) {
      _showSnackBar(context, 'An error occurred: $error');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // Show loader when loading
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign in to Continue',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _handleSignIn(context),
                    child: const Text('Sign in with Google'),
                  ),
                ],
              ),
      ),
    );
  }
}
