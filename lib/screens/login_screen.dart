import 'package:chitral_dost_app/screens/bottom_navbar.dart';
import 'package:chitral_dost_app/screens/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _getHumanReadableError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No account found with this email';
        case 'wrong-password':
          return 'Incorrect password';
        case 'invalid-email':
          return 'Invalid email address';
        case 'user-disabled':
          return 'Account has been disabled';
        case 'too-many-requests':
          return 'Too many attempts. Try again later';
        case 'network-request-failed':
          return 'Network error. Check your connection';
        default:
          return 'Login failed. Please try again';
      }
    }
    return 'An unexpected error occurred';
  }

  Future<void> _loginUser() async {
    if (_isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavbar()),
        (route) => false,
      );

    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getHumanReadableError(error)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _navigateToSignUp() {
    if (_isLoading || !mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.08),

              // Logo
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: height * 0.18,
                ),
              ),
              SizedBox(height: height * 0.03),

              // App Name
              Text(
                "Chitral Dost",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: width * 0.08,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: height * 0.01),

              // Tagline
              Text(
                "Your Trusted Partner for Home Services",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: width * 0.045,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: height * 0.05),

              // Login Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.03),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _loginUser(),
                    ),
                    SizedBox(height: height * 0.05),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _loginUser,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                            : Text(
                                "Login",
                                style: TextStyle(fontSize: width * 0.045),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03),

              // Sign Up Option
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: width * 0.04),
                  ),
                  InkWell(
                    onTap: _isLoading ? null : _navigateToSignUp,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: width * 0.045,
                        color: _isLoading 
                            ? Colors.grey 
                            : Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}