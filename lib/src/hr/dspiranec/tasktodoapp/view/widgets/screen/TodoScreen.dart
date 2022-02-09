import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/logic/service/TodoService.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/model/Todo.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/model/TodoItem.dart';

class TodoScreen extends StatefulWidget {
  final String userId;

  const TodoScreen({
    Key key,
    this.userId,
  }) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState(userId);
}

class _TodoScreenState extends State<TodoScreen> {
  final String _userId;
  List<Todo> todos = <Todo>[];

  _TodoScreenState(this._userId);

  @override
  void initState() {
    super.initState();
    _getTodoListFromCurrUser();
  }

  _getTodoListFromCurrUser() async {
    List<Todo> todoss = await TodoService().getTodoListByUserId(_userId);
    setState(() {
      todos = todoss;
    });
  }

  _updateTodoListWithUserId(String userId, List<Todo> todos) async {
    await TodoService().updateTodoListWithUserId(userId, todos);
  }

  void _handleTodoChange(Todo todo) async {
    setState(() {
      todo.checked = !todo.checked;
    });
  await _updateTodoListWithUserId(_userId, todos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            tr("Home.naslov"),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: todos.isEmpty
          ? Column(
              children: [
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ],
            )
          : ListView(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              children: todos.map((Todo todo) {
                return TodoItem(
                  todo: todo,
                  onTodoChanged: _handleTodoChange,
                );
              }).toList(),
            ),
    );
  }
}
