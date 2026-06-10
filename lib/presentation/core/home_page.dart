import 'package:articly/data/services/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          children: [
            Text('Welcome to Articly!'),
            ElevatedButton(
              onPressed: () {
                AuthService().signOut();
              },
              child: Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
