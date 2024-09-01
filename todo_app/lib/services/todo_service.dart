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
        print('Todos received: $body'); // Cetak data untuk debugging
        return body.map((dynamic item) => Todo.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load todos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching todos: $e');
      throw e;
    }
  }

  Future<Todo> createTodo(String title) async {
    return _handleRequest<Todo>(
      () async {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'title': title}),
        );
        return Todo.fromJson(jsonDecode(response.body));
      },
      'Failed to create todo',
    );
  }

  Future<Todo> updateTodo(String id, Todo todo) async {
    return _handleRequest<Todo>(
      () async {
        final response = await http.patch(
          Uri.parse('$apiUrl/$id'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(todo.toJson()),
        );
        return Todo.fromJson(jsonDecode(response.body));
      },
      'Failed to update todo',
    );
  }

  Future<void> deleteTodo(String id) async {
    await _handleRequest<void>(
      () async {
        final response = await http.delete(Uri.parse('$apiUrl/$id'));
        if (response.statusCode != 200) {
          throw Exception('Failed to delete todo');
        }
      },
      'Failed to delete todo',
    );
  }

  Future<T> _handleRequest<T>(
      Future<T> Function() request, String errorMessage) async {
    try {
      return await request();
    } catch (e) {
      print('Error: $e');
      throw Exception(errorMessage);
    }
  }
}
