import 'package:flutter/material.dart';
import 'package:flutter_amplify_datastore/models/Todo.dart';
import 'package:flutter_amplify_datastore/widgets/todo_item.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;

  TodoList({required this.todos});

  @override
  Widget build(BuildContext context) {
    return todos.length >= 1
        ? ListView(
            padding: EdgeInsets.all(8),
            children: todos.map((todo) => TodoItem(todo: todo)).toList())
        : Center(child: Text('Ninguna tarea. ¡Crea una nueva con el botón "Nueva Tarea"!'));
  }
}