import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/group.dart';
import '../models/expense.dart';
import '../models/activity.dart';
import 'package:uuid/uuid.dart';

class MockDataService {
  static const String _usersKey = 'users';
  static const String _groupsKey = 'groups';
  static const String _expensesKey = 'expenses';
  static const String _activitiesKey = 'activities';
  static const String _currentUserKey = 'currentUser';

  final Uuid _uuid = const Uuid();

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // Mock data initialization
  Future<void> initializeMockData() async {
    final prefs = await _prefs;
    if (prefs.getString(_usersKey) == null) {
      // Create mock users
      final users = [
        User(id: _uuid.v4(), name: 'John Doe', email: 'john@example.com'),
        User(id: _uuid.v4(), name: 'Jane Smith', email: 'jane@example.com'),
        User(id: _uuid.v4(), name: 'Bob Johnson', email: 'bob@example.com'),
      ];
      await _saveUsers(users);
      
      // Create mock group
      final group = Group(
        id: _uuid.v4(),
        name: 'Summer Trip 2025',
        currency: 'USD',
        memberIds: users.map((u) => u.id).toList(),
        createdBy: users[0].id,
        createdAt: DateTime.now(),
      );
      await _saveGroup(group);
      
      // Create mock expenses
      final expenses = [
        Expense(
          id: _uuid.v4(),
          groupId: group.id,
          description: 'Dinner at restaurant',
          amount: 120.0,
          paidBy: users[0].id,
          participants: users.map((u) => u.id).toList(),
          splitType: SplitType.equal,
          splits: {users[0].id: 40.0, users[1].id: 40.0, users[2].id: 40.0},
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ];
      await _saveExpenses(expenses);
      
      // Create mock activities
      final activities = [
        Activity(
          id: _uuid.v4(),
          groupId: group.id,
          userId: users[0].id,
          type: 'expense_added',
          message: 'John added \$120 for dinner',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ];
      await _saveActivities(activities);
    }
  }

  // User operations
  Future<List<User>> getUsers() async {
    final prefs = await _prefs;
    final usersJson = prefs.getStringList(_usersKey) ?? [];
    return usersJson.map((json) => User.fromMap(jsonDecode(json))).toList();
  }

  Future<User?> getCurrentUser() async {
    final prefs = await _prefs;
    final userJson = prefs.getString(_currentUserKey);
    return userJson != null ? User.fromMap(jsonDecode(userJson)) : null;
  }

  Future<void> setCurrentUser(User user) async {
    final prefs = await _prefs;
    await prefs.setString(_currentUserKey, jsonEncode(user.toMap()));
  }

  // Group operations
  Future<List<Group>> getGroups() async {
    final prefs = await _prefs;
    final groupsJson = prefs.getStringList(_groupsKey) ?? [];
    return groupsJson.map((json) => Group.fromMap(jsonDecode(json))).toList();
  }

  Future<Group?> getGroup(String id) async {
    final groups = await getGroups();
    return groups.firstWhere((g) => g.id == id);
  }

  Future<void> addGroup(Group group) async {
    final groups = await getGroups();
    groups.add(group);
    await _saveGroups(groups);
  }

  // Expense operations
  Future<List<Expense>> getExpenses(String groupId) async {
    final prefs = await _prefs;
    final expensesJson = prefs.getStringList(_expensesKey) ?? [];
    final expenses = expensesJson.map((json) => Expense.fromMap(jsonDecode(json))).toList();
    return expenses.where((e) => e.groupId == groupId).toList();
  }

  Future<void> addExpense(Expense expense) async {
    final prefs = await _prefs;
    final expensesJson = prefs.getStringList(_expensesKey) ?? [];
    expensesJson.add(jsonEncode(expense.toMap()));
    await prefs.setStringList(_expensesKey, expensesJson);
  }

  // Activity operations
  Future<List<Activity>> getActivities(String groupId) async {
    final prefs = await _prefs;
    final activitiesJson = prefs.getStringList(_activitiesKey) ?? [];
    final activities = activitiesJson.map((json) => Activity.fromMap(jsonDecode(json))).toList();
    return activities.where((a) => a.groupId == groupId).toList();
  }

  Future<void> addActivity(Activity activity) async {
    final prefs = await _prefs;
    final activitiesJson = prefs.getStringList(_activitiesKey) ?? [];
    activitiesJson.add(jsonEncode(activity.toMap()));
    await prefs.setStringList(_activitiesKey, activitiesJson);
  }

  // Helper methods
  Future<void> _saveUsers(List<User> users) async {
    final prefs = await _prefs;
    final usersJson = users.map((u) => jsonEncode(u.toMap())).toList();
    await prefs.setStringList(_usersKey, usersJson);
  }

  Future<void> _saveGroup(Group group) async {
    final groups = await getGroups();
    groups.add(group);
    await _saveGroups(groups);
  }

  Future<void> _saveGroups(List<Group> groups) async {
    final prefs = await _prefs;
    final groupsJson = groups.map((g) => jsonEncode(g.toMap())).toList();
    await prefs.setStringList(_groupsKey, groupsJson);
  }

  Future<void> _saveExpenses(List<Expense> expenses) async {
    final prefs = await _prefs;
    final expensesJson = expenses.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList(_expensesKey, expensesJson);
  }

  Future<void> _saveActivities(List<Activity> activities) async {
    final prefs = await _prefs;
    final activitiesJson = activities.map((a) => jsonEncode(a.toMap())).toList();
    await prefs.setStringList(_activitiesKey, activitiesJson);
  }
}