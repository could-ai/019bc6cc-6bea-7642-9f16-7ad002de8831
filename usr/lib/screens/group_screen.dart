import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/group.dart';
import '../models/expense.dart';
import '../models/activity.dart';
import '../models/user.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  Group? _group;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _group = ModalRoute.of(context)?.settings.arguments as Group?;
    if (_group != null) {
      context.read<AppProvider>().loadGroupData(_group!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_group == null) {
      return const Scaffold(body: Center(child: Text('Group not found')));
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_group!.name),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Expenses'),
              Tab(text: 'Balance'),
              Tab(text: 'Activity'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildExpensesTab(),
            _buildBalanceTab(),
            _buildActivityTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/add-expense', arguments: _group),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildExpensesTab() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final expenses = provider.expenses;
        if (expenses.isEmpty) {
          return const Center(child: Text('No expenses yet'));
        }

        return ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final expense = expenses[index];
            return ListTile(
              title: Text(expense.description),
              subtitle: Text('\$${expense.amount.toStringAsFixed(2)}'),
              trailing: Text(expense.isSettled ? 'Settled' : 'Pending'),
            );
          },
        );
      },
    );
  }

  Widget _buildBalanceTab() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final balances = provider.calculateBalances(_group!.id);
        final users = provider.groups
            .expand((g) => g.memberIds)
            .toSet()
            .map((id) => User(id: id, name: 'User $id', email: ''))
            .toList();

        return ListView.builder(
          itemCount: balances.length,
          itemBuilder: (context, index) {
            final userId = balances.keys.elementAt(index);
            final balance = balances[userId]!;
            final user = users.firstWhere((u) => u.id == userId);
            return ListTile(
              title: Text(user.name),
              trailing: Text(
                '\$${balance.toStringAsFixed(2)}',
                style: TextStyle(
                  color: balance >= 0 ? Colors.green : Colors.red,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActivityTab() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final activities = provider.activities;
        if (activities.isEmpty) {
          return const Center(child: Text('No activities yet'));
        }

        return ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return ListTile(
              title: Text(activity.message),
              subtitle: Text(activity.createdAt.toString()),
            );
          },
        );
      },
    );
  }
}