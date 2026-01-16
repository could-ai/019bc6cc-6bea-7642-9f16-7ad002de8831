import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/group.dart';
import '../models/user.dart';
import '../services/mock_data_service.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _groupNameController = TextEditingController();
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await context.read<AppProvider>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.groups.length,
            itemBuilder: (context, index) {
              final group = provider.groups[index];
              return Card(
                child: ListTile(
                  title: Text(group.name),
                  subtitle: Text('${group.memberIds.length} members'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () => _openGroup(group),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateGroupDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openGroup(Group group) {
    Navigator.pushNamed(
      context,
      '/group',
      arguments: group,
    );
  }

  void _showCreateGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Group'),
        content: TextField(
          controller: _groupNameController,
          decoration: const InputDecoration(
            labelText: 'Group Name',
            hintText: 'e.g., Summer Trip 2025',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _createGroup,
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _createGroup() async {
    if (_groupNameController.text.isEmpty) return;

    final provider = context.read<AppProvider>();
    final user = provider.currentUser;
    if (user == null) return;

    final newGroup = Group(
      id: _uuid.v4(),
      name: _groupNameController.text,
      currency: 'USD',
      memberIds: [user.id],
      createdBy: user.id,
      createdAt: DateTime.now(),
    );

    await provider.addGroup(newGroup);
    _groupNameController.clear();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }
}