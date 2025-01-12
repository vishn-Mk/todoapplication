import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import toast package
import '../provider/task_provider.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<TaskProvider>().fetchTasks(); // Fetch tasks on load
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'To-Do App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.indigo[300], // Standard app bar color
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TaskFormScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(  // Listens for changes in TaskProvider
        builder: (context, taskProvider, _) {
          final tasks = taskProvider.tasks;
          if (tasks.isEmpty) {
            return const Center(
              child: Text(
                'No tasks available.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300), // Animation duration
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: task.isCompleted
                      ? Colors.green.shade50
                      : Colors.blueGrey.shade50, // Dynamic background color
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: task.isCompleted
                          ? Colors.green.shade800
                          : Colors.indigo, // Dynamic title color
                    ),
                  ),
                  subtitle: Text(
                    task.description,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.indigo),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskFormScreen(
                                task: task, // Pass task for editing
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          task.isCompleted
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color:
                          task.isCompleted ? Colors.green : Colors.grey,
                        ),
                        onPressed: () async {
                          task.isCompleted = !task.isCompleted;
                          await taskProvider.updateTask(task);
                          Fluttertoast.showToast(
                            msg: 'Task updated successfully',
                            backgroundColor: Colors.green,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await taskProvider.deleteTask(task.id);
                          Fluttertoast.showToast(
                            msg: 'Task deleted successfully',
                            backgroundColor: Colors.red,
                          );
                        },
                      ),
                    ],
                  ),
                  onLongPress: () async {
                    await taskProvider.deleteTask(task.id);
                    Fluttertoast.showToast(
                      msg: 'Task deleted successfully',
                      backgroundColor: Colors.red,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
