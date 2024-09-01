import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoService _todoService = TodoService();
  late Future<List<Todo>> _todoList;

  @override
  void initState() {
    super.initState();
    _todoList = _todoService.getTodos();
  }

  Future<void> _refreshTodos() async {
    setState(() {
      _todoList = _todoService.getTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
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
            print('Todos data: ${snapshot.data}'); // Debugging line
            return RefreshIndicator(
              onRefresh: _refreshTodos,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Todo todo = snapshot.data![index];
                  return ListTile(
                    title: Text(todo.title),
                    trailing: Checkbox(
                      value: todo.completed,
                      onChanged: (bool? value) {
                        setState(() {
                          todo.completed = value!;
                          _todoService.updateTodo(todo.id, todo);
                        });
                      },
                    ),
                    onLongPress: () async {
                      await _todoService.deleteTodo(todo.id);
                      _refreshTodos();
                    },
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final String? title = await _showAddTodoDialog(context);
          if (title != null) {
            await _todoService.createTodo(title);
            _refreshTodos();
          }
        },
      ),
    );
  }

  Future<String?> _showAddTodoDialog(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Todo'),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: 'Enter todo title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(_controller.text),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
