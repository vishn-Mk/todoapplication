import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import toast package
import '../model/task.dart';
import '../provider/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({Key? key, this.task}) : super(key: key);

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();

    // If editing a task, populate the controllers with task details
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _isCompleted = widget.task!.isCompleted;
    }
  }

  void _saveTask() {
    final task = Task(
      id: widget.task?.id ?? DateTime.now().toString(), // Use existing ID if editing
      title: _titleController.text,
      description: _descriptionController.text,
      isCompleted: _isCompleted,
    );

    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    if (widget.task == null) {
      // If no task is passed, it's an "add" operation
      taskProvider.addTask(task);
      Fluttertoast.showToast(
        msg: 'Task added successfully',
        backgroundColor: Colors.green,
      );
    } else {
      // If task is passed, it's an "edit" operation
      taskProvider.updateTask(task);
      Fluttertoast.showToast(
        msg: 'Task updated successfully',
        backgroundColor: Colors.blue,
      );
    }

    Navigator.pop(context); // Go back to the home screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.task == null ? const Text('Add Task') : const Text('Edit Task'),
        backgroundColor: Colors.purple, // AppBar color change
        elevation: 6, // Elevation for a more prominent app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Allow scrolling in case of keyboard visibility
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
                style: TextStyle(color: Colors.deepPurple),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Task Description',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
                style: TextStyle(color: Colors.deepPurple),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isCompleted,
                    onChanged: (value) {
                      setState(() {
                        _isCompleted = value!;
                      });
                    },
                    activeColor: Colors.deepPurple, // Checkbox color
                  ),
                  const Text(
                    'Completed',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Button color
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _saveTask,
                  child: Text(
                    widget.task == null ? 'Add Task' : 'Update Task',
                    style: TextStyle(color:Colors.black,fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
