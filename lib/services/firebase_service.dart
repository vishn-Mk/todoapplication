import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/task.dart';


class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all tasks from Firestore
  Future<List<Task>> fetchTasks() async {
    final snapshot = await _firestore.collection('tasks').get();
    return snapshot.docs
        .map((doc) => Task.fromFirestore(doc))
        .toList();
  }

  // Add a new task to Firestore
  Future<void> addTask(Task task) async {
    await _firestore.collection('tasks').add(task.toMap());
  }

  // Update an existing task in Firestore
  Future<void> updateTask(Task task) async {
    await _firestore.collection('tasks').doc(task.id).update(task.toMap());
  }

  // Delete a task from Firestore
  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }
}
