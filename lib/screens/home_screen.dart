import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        leading: Icon(Icons.miscellaneous_services),
        title: Text(
          'CHITRAL DOST',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Card(
        color: const Color.fromARGB(255, 131, 71, 71),
        margin: EdgeInsets.all(12),
        elevation: 2,
      ),
    );
  }
}
