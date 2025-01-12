import 'package:flutter/material.dart';
import '../model/task.dart';

import '../services/firebase_service.dart';


class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final FirebaseService _firebaseService = FirebaseService();

  List<Task> get tasks => _tasks;

  void setTasks(List<Task> tasks) {
    _tasks = tasks;
    notifyListeners();
  }

  // Fetch tasks using FirebaseService
  Future<void> fetchTasks() async {
    final tasks = await _firebaseService.fetchTasks();
    setTasks(tasks);
  }

  // Add a task using FirebaseService
  Future<void> addTask(Task task) async {
    await _firebaseService.addTask(task);
    _tasks.add(task);
    notifyListeners();
  }

  // Update a task using FirebaseService
  Future<void> updateTask(Task task) async {
    await _firebaseService.updateTask(task);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  // Delete a task using FirebaseService
  Future<void> deleteTask(String id) async {
    await _firebaseService.deleteTask(id);
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}
