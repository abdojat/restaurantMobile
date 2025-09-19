import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              // Navigation back to login will happen automatically via AuthWrapper
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (authProvider.user != null) ...[
              Text(
                'Welcome, ${authProvider.user!.name}!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
            ],
            const Text('You are now logged in!'),
          ],
        ),
      ),
    );
  }
}
