import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 206, 8, 196),
        title: Text('Login'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),

          child: Card(
            color: const Color.fromARGB(255, 206, 8, 196),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: 'enter your email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 25),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: 'enter your passward',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Login', style: TextStyle(fontSize: 15)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
