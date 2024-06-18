import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:test_app_three/model.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  List<User> get users => _filteredUsers;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  Future<void> fetchUsers() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
      if (response.statusCode == 200) {
        _users = (json.decode(response.body) as List)
            .map((data) => User.fromJson(data))
            .toList();
        _filteredUsers = _users;
        _isLoading = false;
        notifyListeners();
      } else {
        _hasError = true;
        _errorMessage = 'Failed to load users';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      _filteredUsers = _users;
    } else {
      _filteredUsers = _users.where((user) {
        final userName = user.name.toLowerCase();
        final searchQuery = query.toLowerCase();
        return userName.contains(searchQuery);
      }).toList();
    }
    notifyListeners();
  }
}
