// lib/services/todo_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/todo.dart';

class TodoApiService {
  final String baseurl;
  final String token;

  TodoApiService(this.baseurl, this.token);

  Future<List<Todo>> getTodos() async {
    final response = await http.get(
      Uri.parse(baseurl),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('取得資料失敗');
    }
  }

  Future<Todo> addTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse(baseurl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(todo.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception('新增失敗');
    }
  }

  Future<Todo> updateTodo(String id, Todo todo) async {
    final response = await http.put(
      Uri.parse('$baseurl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(todo.toJson()),
    );
    if (response.statusCode == 200) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception('更新失敗');
    }
  }

  Future<void> deleteTodo(String id) async {
    final response = await http.delete(
      Uri.parse('$baseurl/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('刪除失敗');
    }
  }
}
