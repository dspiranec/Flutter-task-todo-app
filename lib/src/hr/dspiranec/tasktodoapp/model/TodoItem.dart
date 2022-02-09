import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Todo.dart';

class TodoItem extends StatelessWidget {
  TodoItem({
    this.todo,
    this.onTodoChanged,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final onTodoChanged;

  TextStyle _getTextStyle(bool checked) {
    if (!checked) {
      return TextStyle(
        fontSize: 24,
      );
    }

    return TextStyle(
      fontSize: 24,
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTodoChanged(todo);
      },
      leading: CircleAvatar(
        backgroundColor: todo.checked ? Colors.grey : Colors.green,
        child: Icon(
          Icons.where_to_vote_outlined,
          color: Colors.white,
        ),
      ),
      title: Text(todo.name, style: _getTextStyle(todo.checked)),
    );
  }
}
