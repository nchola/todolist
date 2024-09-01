import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TodoService {
  final String apiUrl = dotenv.env['API_URL']!;

  Future<List<Todo>> getTodos() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Todo.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load todos');
      }
    } catch (e) {
      print('Error fetching todos: $e');
      throw e;
    }
  }

  Future<Todo> createTodo(String title) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': title}),
      );
      if (response.statusCode == 201) {
        return Todo.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create todo');
      }
    } catch (e) {
      print('Error creating todo: $e');
      throw e;
    }
  }

  Future<Todo> updateTodo(String id, Todo todo) async {
    try {
      final response = await http.patch(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(todo.toJson()),
      );
      if (response.statusCode == 200) {
        return Todo.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update todo');
      }
    } catch (e) {
      print('Error updating todo: $e');
      throw e;
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete todo');
      }
    } catch (e) {
      print('Error deleting todo: $e');
      throw e;
    }
  }
}
