import 'package:flutter/material.dart';
import '../services/mock_data_service.dart';
import '../models/user.dart';
import '../models/group.dart';
import '../models/expense.dart';
import '../models/activity.dart';

class AppProvider extends ChangeNotifier {
  final MockDataService _dataService = MockDataService();
  
  User? _currentUser;
  List<Group> _groups = [];
  List<Expense> _expenses = [];
  List<Activity> _activities = [];
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  List<Group> get groups => _groups;
  List<Expense> get expenses => _expenses;
  List<Activity> get activities => _activities;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    await _dataService.initializeMockData();
    _currentUser = await _dataService.getCurrentUser();
    _groups = await _dataService.getGroups();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(User user) async {
    _currentUser = user;
    await _dataService.setCurrentUser(user);
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    await _dataService.setCurrentUser(User(id: '', name: '', email: ''));
    notifyListeners();
  }

  Future<void> loadGroupData(String groupId) async {
    _expenses = await _dataService.getExpenses(groupId);
    _activities = await _dataService.getActivities(groupId);
    notifyListeners();
  }

  Future<void> addGroup(Group group) async {
    await _dataService.addGroup(group);
    _groups = await _dataService.getGroups();
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    await _dataService.addExpense(expense);
    await loadGroupData(expense.groupId);
    notifyListeners();
  }

  Future<void> addActivity(Activity activity) async {
    await _dataService.addActivity(activity);
    await loadGroupData(activity.groupId);
    notifyListeners();
  }

  Map<String, double> calculateBalances(String groupId) {
    final groupExpenses = _expenses.where((e) => e.groupId == groupId && !e.isSettled);
    final balances = <String, double>{};

    for (final expense in groupExpenses) {
      // Add amount to payer
      balances[expense.paidBy] = (balances[expense.paidBy] ?? 0) + expense.amount;
      
      // Subtract splits from participants
      expense.splits.forEach((userId, amount) {
        balances[userId] = (balances[userId] ?? 0) - amount;
      });
    }

    return balances;
  }
}