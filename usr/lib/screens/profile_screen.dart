import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/user.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final user = provider.currentUser;
          if (user == null) {
            return const Center(child: Text('No user logged in'));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 50),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(user.email),
                const SizedBox(height: 32),
                ListTile(
                  title: const Text('Preferred Currency'),
                  subtitle: Text(user.preferredCurrency),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Currency editing coming soon')),
                    );
                  },
                ),
                const Divider(),
                ElevatedButton(
                  onPressed: () async {
                    await provider.logout();
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}