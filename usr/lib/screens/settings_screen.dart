import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                // TODO: Implement theme switching
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Theme switching coming soon')),
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Currency'),
            subtitle: const Text('USD'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Currency settings coming soon')),
              );
            },
          ),
          ListTile(
            title: const Text('Export Data'),
            trailing: const Icon(Icons.download),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export feature coming soon')),
              );
            },
          ),
          ListTile(
            title: const Text('Notifications'),
            trailing: const Icon(Icons.notifications),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification settings coming soon')),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.privacy_tip),
            onTap: () {
              // TODO: Open privacy policy
            },
          ),
          ListTile(
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.description),
            onTap: () {
              // TODO: Open terms
            },
          ),
          ListTile(
            title: const Text('About'),
            trailing: const Icon(Icons.info),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Group Expense Manager',
                applicationVersion: '1.0.0',
              );
            },
          ),
        ],
      ),
    );
  }
}