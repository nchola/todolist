import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart'; // For formatting date/time
import 'package:todo_app/widgets/add_todo.dart';
import 'package:todo_app/widgets/color_picker.dart';
import '../main.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';
import 'package:timezone/timezone.dart' as tz;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoService _todoService = TodoService();
  late Future<List<Todo>> _todoList;
  bool _isDarkMode = false;
  List<String> _categories = ['All', 'Work', 'Personal'];
  List<String> _availableLabels = [
    'Urgent',
    'Important',
    'Later'
  ]; // Available labels
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _refreshTodos();
  }

  Future<void> _refreshTodos() async {
    setState(() {
      _todoList = _selectedCategory == 'All'
          ? _todoService.getTodos()
          : _todoService.getTodosByCategory(_selectedCategory);
    });
  }

  void _onMenuItemSelected(String choice, Todo todo) async {
    switch (choice) {
      case 'Edit':
        await _showEditTodoDialog(context, todo);
        break;
      case 'Delete':
        try {
          await _todoService.deleteTodo(todo.id);
          _refreshTodos();
        } catch (e) {
          _showSnackBar('Failed to delete todo: ${e.toString()}');
        }
        break;
      case 'Mark as Done':
        setState(() {
          todo.completed = true;
          _todoService.updateTodo(todo.id, todo);
        });
        break;
      case 'Schedule':
        await _showScheduleDialog(context, todo);
        break;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _addNewList(String listName) {
    setState(() {
      _categories.add(listName);
      _selectedCategory = listName;
    });
  }

  Future<void> _showScheduleDialog(BuildContext context, Todo todo) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final DateTime scheduledDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        await _scheduleNotification(todo, scheduledDateTime);

        _showSnackBar(
          'Scheduled ${todo.title} for ${DateFormat('yyyy-MM-dd – kk:mm').format(scheduledDateTime)}',
        );
      }
    }
  }

  Future<void> _scheduleNotification(Todo todo, DateTime scheduledTime) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'todo_channel',
      'Todo Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      todo.id.hashCode,
      'Reminder: ${todo.title}',
      'You have a scheduled task',
      tz.TZDateTime.from(scheduledTime, tz.local), // Schedule with time zone
      platformChannelSpecifics,
      androidAllowWhileIdle: true, // Ensures notification fires even when idle
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> _showEditTodoDialog(BuildContext context, Todo todo) async {
    TextEditingController _controller = TextEditingController(text: todo.title);
    String selectedColor = todo.colorLabel;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Edit todo title'),
            ),
            SizedBox(height: 20),
            Text('Select Label Color:'),
            ColorPicker(
              selectedColor: selectedColor,
              onColorSelected: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                todo.title = _controller.text;
                todo.colorLabel = selectedColor;
                _todoService.updateTodo(todo.id, todo);
              });
              Navigator.of(context).pop();
              _refreshTodos();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedCategory == 'All'
              ? 'Todo App'
              : 'Todo App - $_selectedCategory',
          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
        ],
        backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.blue,
        iconTheme:
            IconThemeData(color: _isDarkMode ? Colors.white : Colors.black),
      ),
      drawer: _buildDrawer(),
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
      body: FutureBuilder<List<Todo>>(
        future: _todoList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No todos found'));
          } else {
            return RefreshIndicator(
              onRefresh: _refreshTodos,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Todo todo = snapshot.data![index];
                  return _buildTodoItem(todo);
                },
              ),
            );
          }
        },
      ),
      bottomNavigationBar: AddTodo(
        onTaskSubmitted: (task) async {
          if (task.isNotEmpty) {
            await _todoService.createTodo(
                task, _selectedCategory); // Save category with todo
            _refreshTodos();
          }
        },
        isDarkMode: _isDarkMode,
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('All Todos'),
            leading: Icon(Icons.list),
            onTap: () {
              setState(() {
                _selectedCategory = 'All';
                Navigator.pop(context);
                _refreshTodos();
              });
            },
          ),
          ..._categories.map((category) {
            return ListTile(
              title: Text(category),
              leading: Icon(Icons.label),
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                  Navigator.pop(context);
                  _refreshTodos();
                });
              },
            );
          }).toList(),
          Divider(),
          ListTile(
            title: Text("New List"),
            leading: Icon(Icons.add),
            onTap: () async {
              TextEditingController _controller = TextEditingController();
              await showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Create New List'),
                  content: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Enter list name'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        _addNewList(_controller.text);
                        Navigator.pop(context);
                      },
                      child: Text('Create'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTodoItem(Todo todo) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.completed ? TextDecoration.lineThrough : null,
            color: todo.completed
                ? (_isDarkMode ? Colors.grey[400] : Colors.grey)
                : (_isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        subtitle: Text(
            'Category: ${todo.category}, Labels: ${todo.labels.join(', ')}'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _onMenuItemSelected(value, todo),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'Edit',
              child: ListTile(
                leading: Icon(Icons.edit, color: Colors.blue),
                title: Text('Edit'),
              ),
            ),
            PopupMenuItem(
              value: 'Delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete'),
              ),
            ),
            PopupMenuItem(
              value: 'Mark as Done',
              child: ListTile(
                leading: Icon(Icons.done, color: Colors.green),
                title: Text('Mark as Done'),
              ),
            ),
            PopupMenuItem(
              value: 'Schedule',
              child: ListTile(
                leading: Icon(Icons.schedule, color: Colors.orange),
                title: Text('Schedule'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
