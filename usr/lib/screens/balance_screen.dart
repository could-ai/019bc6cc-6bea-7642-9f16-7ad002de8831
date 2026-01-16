import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/group.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final group = ModalRoute.of(context)?.settings.arguments as Group?;
    if (group == null) {
      return const Scaffold(body: Center(child: Text('Group not found')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Group Balance')),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final balances = provider.calculateBalances(group.id);
          
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Balance',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: balances.length,
                    itemBuilder: (context, index) {
                      final userId = balances.keys.elementAt(index);
                      final balance = balances[userId]!;
                      return Card(
                        child: ListTile(
                          title: Text('User $userId'),
                          trailing: Text(
                            '\$${balance.abs().toStringAsFixed(2)}',
                            style: TextStyle(
                              color: balance >= 0 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            balance >= 0 ? 'Owes you' : 'You owe',
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement settlement logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settlement feature coming soon')),
                    );
                  },
                  child: const Text('Settle Balances'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}