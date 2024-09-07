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

  void _onMenuItemSelected(String choice, Todo todo) async {
    switch (choice) {
      case 'Edit':
        await _showEditTodoDialog(context, todo);
        break;
      case 'Delete':
        try {
          await _todoService.deleteTodo(todo.id);
          _refreshTodos(); // Refresh todos after successful delete
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to delete todo: ${e.toString()}'),
          ));
        }
        break;
      case 'Mark as Done':
        setState(() {
          todo.completed = true;
          _todoService.updateTodo(todo.id, todo);
        });
        break;
    }
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
            String errorMessage;
            if (snapshot.error.toString().contains('timed out')) {
              errorMessage = 'Connection timed out. Please try again later.';
            } else {
              errorMessage = 'Error: ${snapshot.error}';
            }
            return Center(child: Text(errorMessage));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No todos found'));
          } else {
            return RefreshIndicator(
              onRefresh: _refreshTodos,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Todo todo = snapshot.data![index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [Colors.grey.shade300, Colors.grey.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.completed
                              ? TextDecoration.lineThrough
                              : null,
                          color: todo.completed ? Colors.grey : null,
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) => _onMenuItemSelected(value, todo),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'Edit',
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit'),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Delete',
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Mark as Done',
                            child: ListTile(
                              leading: Icon(Icons.done),
                              title: Text('Mark as Done'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      bottomNavigationBar: AddTodoInput(
        onTaskSubmitted: (task) async {
          if (task.isNotEmpty) {
            await _todoService.createTodo(task);
            _refreshTodos();
          }
        },
      ),
    );
  }

  Future<void> _showEditTodoDialog(BuildContext context, Todo todo) async {
    TextEditingController _controller = TextEditingController(text: todo.title);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Todo'),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: 'Edit todo title'),
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
}

class AddTodoInput extends StatefulWidget {
  final Function(String) onTaskSubmitted;

  AddTodoInput({required this.onTaskSubmitted});

  @override
  _AddTodoInputState createState() => _AddTodoInputState();
}

class _AddTodoInputState extends State<AddTodoInput> {
  bool _isClicked = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _onClick() {
    setState(() {
      _isClicked = true;
    });
    _focusNode.requestFocus(); // Request focus to show the keyboard
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onClick,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _isClicked ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isClicked ? Colors.blue : Colors.grey,
            width: _isClicked ? 1.5 : 1,
          ),
        ),
        child: _isClicked
            ? TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Enter a task',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  widget.onTaskSubmitted(value);
                  setState(() {
                    _controller.clear();
                    _isClicked = false;
                  });
                },
              )
            : Center(child: Text('Add Todo')),
      ),
    );
  }
}
