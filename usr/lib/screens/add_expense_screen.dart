import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/app_provider.dart';
import '../models/group.dart';
import '../models/expense.dart';
import '../models/activity.dart';
import 'package:uuid/uuid.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _uuid = const Uuid();
  Group? _group;
  String? _selectedPayer;
  SplitType _splitType = SplitType.equal;
  List<String> _participants = [];
  File? _receiptImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _group = ModalRoute.of(context)?.settings.arguments as Group?;
    if (_group != null) {
      _participants = List.from(_group!.memberIds);
      _selectedPayer = _group!.memberIds.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        actions: [
          TextButton(
            onPressed: _saveExpense,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'e.g., Dinner at restaurant',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPayer,
              decoration: const InputDecoration(labelText: 'Paid by'),
              items: _group?.memberIds.map((id) {
                return DropdownMenuItem(value: id, child: Text('User $id'));
              }).toList(),
              onChanged: (value) => setState(() => _selectedPayer = value),
            ),
            const SizedBox(height: 16),
            const Text('Split Type'),
            DropdownButton<SplitType>(
              value: _splitType,
              items: SplitType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) => setState(() => _splitType = value!),
            ),
            const SizedBox(height: 16),
            const Text('Participants'),
            Wrap(
              children: _group?.memberIds.map((id) {
                final isSelected = _participants.contains(id);
                return FilterChip(
                  label: Text('User $id'),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _participants.add(id);
                      } else {
                        _participants.remove(id);
                      }
                    });
                  },
                );
              }).toList() ?? [],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickReceiptImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Add Receipt'),
            ),
            if (_receiptImage != null) ...[
              const SizedBox(height: 8),
              Image.file(_receiptImage!, height: 100),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickReceiptImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _receiptImage = File(pickedFile.path));
    }
  }

  void _saveExpense() async {
    if (_descriptionController.text.isEmpty || 
        _amountController.text.isEmpty || 
        _selectedPayer == null || 
        _group == null) {
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null) return;

    final splits = _calculateSplits(amount);

    final expense = Expense(
      id: _uuid.v4(),
      groupId: _group!.id,
      description: _descriptionController.text,
      amount: amount,
      paidBy: _selectedPayer!,
      participants: _participants,
      splitType: _splitType,
      splits: splits,
      receiptImage: _receiptImage?.path,
      createdAt: DateTime.now(),
    );

    final provider = context.read<AppProvider>();
    await provider.addExpense(expense);

    // Add activity
    final activity = Activity(
      id: _uuid.v4(),
      groupId: _group!.id,
      userId: provider.currentUser!.id,
      type: 'expense_added',
      message: '${provider.currentUser!.name} added \$${amount.toStringAsFixed(2)} for ${_descriptionController.text}',
      createdAt: DateTime.now(),
    );
    await provider.addActivity(activity);

    Navigator.pop(context);
  }

  Map<String, double> _calculateSplits(double amount) {
    final splits = <String, double>{};
    final participantCount = _participants.length;

    switch (_splitType) {
      case SplitType.equal:
        final splitAmount = amount / participantCount;
        for (final participant in _participants) {
          splits[participant] = splitAmount;
        }
        break;
      case SplitType.unequal:
        // For simplicity, equal split for unequal case (would need more UI)
        final splitAmount = amount / participantCount;
        for (final participant in _participants) {
          splits[participant] = splitAmount;
        }
        break;
      case SplitType.percentage:
        // For simplicity, equal split for percentage case
        final splitAmount = amount / participantCount;
        for (final participant in _participants) {
          splits[participant] = splitAmount;
        }
        break;
      case SplitType.shares:
        // For simplicity, equal split for shares case
        final splitAmount = amount / participantCount;
        for (final participant in _participants) {
          splits[participant] = splitAmount;
        }
        break;
    }

    return splits;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}