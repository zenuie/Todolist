// lib/viewmodels/todo_view_model.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../helpers/auth_helper.dart';
import '../models/todo.dart';
import '../services/todo_api_service.dart';

class TodoViewModel extends ChangeNotifier {
  List<Todo> _todos = [];
  List<Todo> get todos => List.unmodifiable(_todos);

  TodoApiService? _api;

  // 初始化 API（取得 token 並建立 service）
  Future<void> init() async {
    final baseUrl = dotenv.env['BASE_URL'];
    if (baseUrl == null || baseUrl.isEmpty) {
      throw Exception('BASE_URL 未設定');
    }
    final token = await getTestToken() as String;
    _api = TodoApiService(baseUrl, token);
  }

  // 從後端取得資料
  Future<void> fetchTodos() async {
    if (_api == null) {
      await init();
    }
    try {
      final serverTodos = await _api!.getTodos();
      _todos = serverTodos;
      notifyListeners();
    } catch (e) {
      print('取得資料失敗: $e');
    }
  }

  // 新增 Todo（同步到後端）
  Future<void> addTodo(Todo todo) async {
    if (_api == null) {
      await init();
    }
    try {
      final newTodo = await _api!.addTodo(todo);
      _todos.add(newTodo);
      notifyListeners();
    } catch (e) {
      print('新增失敗: $e');
    }
  }

  // 刪除 Todo（同步到後端）
  Future<void> removeTodo(String id) async {
    if (_api == null) {
      await init();
    }
    try {
      await _api!.deleteTodo(id);
      _todos.removeWhere((todo) => todo.id == id);
      notifyListeners();
    } catch (e) {
      print('刪除失敗: $e');
    }
  }

  // 更新 Todo（同步到後端）
  Future<void> updateTodo(Todo todo) async {
    if (_api == null) {
      await init();
    }
    try {
      final updatedTodo = await _api!.updateTodo(todo.id, todo);
      final index = _todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        _todos[index] = updatedTodo;
        notifyListeners();
      }
    } catch (e) {
      print('更新失敗: $e');
    }
  }

  // 切換完成狀態
  Future<void> toggleComplete(String id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final todo = _todos[index];
      final updated = Todo(
        id: todo.id,
        userId: todo.userId,
        title: todo.title,
        description: todo.description,
        complete: todo.complete,
        sort: todo.sort,
        createdAt: todo.createdAt,
        updatedAt: DateTime.now(),
      );
      await updateTodo(updated);
    }
  }
}
