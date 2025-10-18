import 'package:chitral_dost_app/screens/bottom_navbar.dart';
import 'package:chitral_dost_app/screens/sign_up.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    double verticalSpace(double fraction) => height * fraction;
    double horizontalPadding = width * 0.08;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: verticalSpace(0.08)),

              // Logo
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: height * 0.18,
                ),
              ),
              SizedBox(height: verticalSpace(0.03)),

              // App Name
              Text(
                "Chitral Dost",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: width * 0.08,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: verticalSpace(0.01)),

              // Tagline
              Text(
                "Your Trusted Partner for Home Services",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: width * 0.045),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: verticalSpace(0.05)),

              // Login Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: verticalSpace(0.03)),

                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: verticalSpace(0.05)),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavbar(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          }
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: width * 0.045),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: verticalSpace(0.03)),

              // Sign Up Option
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an account? ",
                    style: TextStyle(fontSize: width * 0.04),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: width * 0.045,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: verticalSpace(0.05)),
            ],
          ),
        ),
      ),
    );
  }
}
