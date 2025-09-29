import 'package:chitral_dost_app/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

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
                  'assets/images/logo1.png',
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

              // Sign Up Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter your Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your Name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: verticalSpace(0.03)),

                    TextFormField(
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

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // After successful sign-up, go to Login screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontSize: width * 0.045),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: verticalSpace(0.03)),

              // Already have an account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: width * 0.045,
                        color: Theme.of(context).primaryColor,
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
