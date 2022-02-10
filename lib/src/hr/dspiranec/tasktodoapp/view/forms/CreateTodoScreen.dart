import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/logic/service/TodoService.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/model/Todo.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/model/TodoItem.dart';

class CreateTodoScreen extends StatefulWidget {
  const CreateTodoScreen({Key key}) : super(key: key);

  @override
  _CreateTodoScreenState createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  final TextEditingController _textFieldController = TextEditingController();
  String userId;
  List<Todo> todoList = <Todo>[];

  @override
  void initState() {
    super.initState();
    _fetchLocalStorageData();
    _getTodoListByUserId();
  }

  _fetchLocalStorageData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }

  _getTodoListByUserId() async {
    List<Todo> todos = await TodoService().getTodoListByUserId(userId);
    setState(() {
      todoList = todos;
    });
  }

  _syncTodoToAllUsers() async {
    await TodoService().syncTodoToAllUsers(todoList);
  }

  _syncTodoList() async {
    await _syncTodoToAllUsers();
    setState(() {
      todoList.clear();
    });
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text('Uspješno sinkronizirana TODO lista svim korisnicima'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _createNewTodo() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dodaj novi task na TODO list'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'novi todo'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Dodaj'),
              onPressed: () async {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void _addTodoItem(String name) {
    setState(() {
      todoList.add(Todo(name: name, checked: false));
    });
    _textFieldController.clear();
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Kreiraj novu TODO listu",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: todoList.map((Todo todo) {
          return TodoItem(
            todo: todo,
            onTodoChanged: null,
          );
        }).toList(),
      ),
      floatingActionButton: Row(
        children: [
          Spacer(),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(5),
            child: FloatingActionButton.extended(
                backgroundColor: Colors.green,
                label: Text(
                  "Sync",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                icon: Icon(Icons.add),
                onPressed: () {
                  _syncTodoList();
                }),
          )),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(5),
            child: FloatingActionButton(
                backgroundColor: Color.fromRGBO(59, 174, 240, 1),
                child: Icon(Icons.remove),
                onPressed: () {
                  setState(() async {
                    todoList.removeLast();
                  });
                }),
          )),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(5),
            child: FloatingActionButton(
                backgroundColor: Color.fromRGBO(59, 174, 240, 1),
                child: Icon(Icons.add),
                onPressed: () {
                  _createNewTodo();
                }),
          )),
        ],
      ),
    );
  }
}
