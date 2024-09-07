// import 'package:flutter/material.dart';
// import '../models/todo.dart';
// import '../services/todo_service.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TodoService _todoService = TodoService();
//   late Future<List<Todo>> _todoList;
//   bool _isDarkMode = false;
//   List<String> _categories = ['All', 'Work', 'Personal'];
//   String _selectedCategory = 'All';

//   @override
//   void initState() {
//     super.initState();
//     _todoList = _todoService.getTodos();
//   }

//   Future<void> _refreshTodos() async {
//     setState(() {
//       _todoList = _todoService.getTodos();
//     });
//   }

//   void _onMenuItemSelected(String choice, Todo todo) async {
//     switch (choice) {
//       case 'Edit':
//         await _showEditTodoDialog(context, todo);
//         break;
//       case 'Delete':
//         try {
//           await _todoService.deleteTodo(todo.id);
//           _refreshTodos();
//         } catch (e) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text('Failed to delete todo: ${e.toString()}'),
//           ));
//         }
//         break;
//       case 'Mark as Done':
//         setState(() {
//           todo.completed = true;
//           _todoService.updateTodo(todo.id, todo);
//         });
//         break;
//     }
//   }

//   void _addNewList(String listName) {
//     setState(() {
//       _categories.add(listName);
//       _selectedCategory = listName;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Todo App'),
//         actions: [
//           IconButton(
//             icon: Icon(_isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
//             onPressed: () {
//               setState(() {
//                 _isDarkMode = !_isDarkMode;
//               });
//             },
//           ),
//         ],
//         backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.blue,
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             ListTile(
//               title: Text('All Todos'),
//               leading: Icon(Icons.list),
//               onTap: () {
//                 setState(() {
//                   _selectedCategory = 'All';
//                   Navigator.pop(context);
//                 });
//               },
//             ),
//             ..._categories.map((category) {
//               return ListTile(
//                 title: Text(category),
//                 leading: Icon(Icons.label),
//                 onTap: () {
//                   setState(() {
//                     _selectedCategory = category;
//                     Navigator.pop(context);
//                   });
//                 },
//               );
//             }).toList(),
//             Divider(),
//             ListTile(
//               title: Text("New List"),
//               leading: Icon(Icons.add),
//               onTap: () async {
//                 TextEditingController _controller = TextEditingController();
//                 await showDialog<void>(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: Text('Create New List'),
//                     content: TextField(
//                       controller: _controller,
//                       decoration: InputDecoration(hintText: 'Enter list name'),
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: Text('Cancel'),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           _addNewList(_controller.text);
//                           Navigator.pop(context);
//                         },
//                         child: Text('Create'),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
//       body: FutureBuilder<List<Todo>>(
//         future: _todoList,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No todos found'));
//           } else {
//             return RefreshIndicator(
//               onRefresh: _refreshTodos,
//               child: ListView.builder(
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   Todo todo = snapshot.data![index];
//                   return Container(
//                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: _isDarkMode ? Colors.grey[800] : Colors.grey[200],
//                     ),
//                     child: ListTile(
//                       title: Text(
//                         todo.title,
//                         style: TextStyle(
//                           decoration: todo.completed
//                               ? TextDecoration.lineThrough
//                               : null,
//                           color: todo.completed
//                               ? (_isDarkMode ? Colors.grey[400] : Colors.grey)
//                               : (_isDarkMode ? Colors.white : Colors.black),
//                         ),
//                       ),
//                       trailing: PopupMenuButton<String>(
//                         onSelected: (value) => _onMenuItemSelected(value, todo),
//                         itemBuilder: (context) => [
//                           PopupMenuItem(
//                             value: 'Edit',
//                             child: ListTile(
//                               leading: Icon(Icons.edit),
//                               title: Text('Edit'),
//                             ),
//                           ),
//                           PopupMenuItem(
//                             value: 'Delete',
//                             child: ListTile(
//                               leading: Icon(Icons.delete),
//                               title: Text('Delete'),
//                             ),
//                           ),
//                           PopupMenuItem(
//                             value: 'Mark as Done',
//                             child: ListTile(
//                               leading: Icon(Icons.done),
//                               title: Text('Mark as Done'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           }
//         },
//       ),
//       bottomNavigationBar: AddTodoInput(
//         onTaskSubmitted: (task) async {
//           if (task.isNotEmpty) {
//             await _todoService.createTodo(task);
//             _refreshTodos();
//           }
//         },
//         isDarkMode: _isDarkMode,
//       ),
//       resizeToAvoidBottomInset: true,
//     );
//   }

//   Future<void> _showEditTodoDialog(BuildContext context, Todo todo) async {
//     TextEditingController _controller = TextEditingController(text: todo.title);
//     await showDialog<void>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Edit Todo'),
//         content: TextField(
//           controller: _controller,
//           decoration: InputDecoration(hintText: 'Edit todo title'),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 todo.title = _controller.text;
//                 _todoService.updateTodo(todo.id, todo);
//               });
//               Navigator.of(context).pop();
//               _refreshTodos();
//             },
//             child: Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AddTodoInput extends StatefulWidget {
//   final Function(String) onTaskSubmitted;
//   final bool isDarkMode;

//   AddTodoInput({required this.onTaskSubmitted, required this.isDarkMode});

//   @override
//   _AddTodoInputState createState() => _AddTodoInputState();
// }

// class _AddTodoInputState extends State<AddTodoInput> {
//   bool _isClicked = false;
//   final TextEditingController _controller = TextEditingController();
//   final FocusNode _focusNode = FocusNode();

//   void _onClick() {
//     setState(() {
//       _isClicked = true;
//     });
//     _focusNode.requestFocus();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _onClick,
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 200),
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: _isClicked
//               ? (widget.isDarkMode ? Colors.grey[700] : Colors.white)
//               : Colors.transparent,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: _isClicked
//                 ? (widget.isDarkMode ? Colors.blueGrey : Colors.blue)
//                 : Colors.grey,
//             width: _isClicked ? 1.5 : 1,
//           ),
//         ),
//         child: _isClicked
//             ? TextField(
//                 controller: _controller,
//                 focusNode: _focusNode,
//                 decoration: InputDecoration(
//                   hintText: 'Enter a task',
//                   border: InputBorder.none,
//                   hintStyle: TextStyle(
//                     color: widget.isDarkMode ? Colors.grey[400] : Colors.grey,
//                   ),
//                 ),
//                 onSubmitted: (value) {
//                   widget.onTaskSubmitted(value);
//                   setState(() {
//                     _controller.clear();
//                     _isClicked = false;
//                   });
//                 },
//                 style: TextStyle(
//                   color: widget.isDarkMode ? Colors.white : Colors.black,
//                 ),
//               )
//             : Center(
//                 child: Text(
//                   'Add Todo',
//                   style: TextStyle(
//                     color: widget.isDarkMode ? Colors.white : Colors.black,
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
// }

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
  bool _isDarkMode = false;
  List<String> _categories = ['All', 'Work', 'Personal'];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _refreshTodos(); // Refresh todos based on selected category
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

  void _addNewList(String listName) {
    setState(() {
      _categories.add(listName);
      _selectedCategory = listName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
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
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('All Todos'),
              leading: Icon(Icons.list),
              onTap: () {
                setState(() {
                  _selectedCategory = 'All';
                  Navigator.pop(context);
                  _refreshTodos(); // Refresh todos on category change
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
                    _refreshTodos(); // Refresh todos on category change
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
      ),
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
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white, // Background putih susu
                      borderRadius: BorderRadius.circular(10), // Ujung tumpul
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // Shadow pada container
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.completed
                                ? TextDecoration.lineThrough
                                : null,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(
                            thickness: 2), // Garis tengah di antara judul todo
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              // Fitur untuk mengatur waktu (Add Timer)
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.timer),
                                SizedBox(width: 5),
                                Text(
                                  'Add Timer',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
            await _todoService.createTodo(
                task, _selectedCategory); // Menyimpan kategori bersama todo
            _refreshTodos();
          }
        },
        isDarkMode: _isDarkMode,
      ),
      resizeToAvoidBottomInset: true,
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
  final bool isDarkMode;

  AddTodoInput({required this.onTaskSubmitted, required this.isDarkMode});

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
    _focusNode.requestFocus();
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
          color: _isClicked
              ? (widget.isDarkMode ? Colors.grey[700] : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isClicked
                ? (widget.isDarkMode ? Colors.blueGrey : Colors.blue)
                : Colors.grey,
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
                  hintStyle: TextStyle(
                    color: widget.isDarkMode ? Colors.grey[400] : Colors.grey,
                  ),
                ),
                onSubmitted: (value) {
                  widget.onTaskSubmitted(value);
                  setState(() {
                    _controller.clear();
                    _isClicked = false;
                  });
                },
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              )
            : Center(
                child: Text(
                  'Add Todo',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
      ),
    );
  }
}
