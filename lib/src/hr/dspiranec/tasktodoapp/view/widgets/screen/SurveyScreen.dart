import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/logic/service/TodoService.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/model/Todo.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/model/TodoItem.dart';

class SurveyScreen extends StatefulWidget {
  final String userId;

  const SurveyScreen({
    Key key,
    this.userId,
  }) : super(key: key);

  @override
  _SurveyScreenState createState() => _SurveyScreenState(userId);
}

class _SurveyScreenState extends State<SurveyScreen> {
  final String _userId;
  List<Todo> todos = <Todo>[];

  _SurveyScreenState(this._userId);

  @override
  void initState() {
    super.initState();
    _getTodoListFromCurrUser();
  }

  _getTodoListFromCurrUser() async {
    return await TodoService().getTodoListByUserId(_userId);
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
            tr("Home.naslov"),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            FutureBuilder(
                future: _getTodoListFromCurrUser(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Text("Nije pronađen ni jedan podatak."),
                    );
                  }
                  return ListView(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    children: todos.map((Todo todo) {
                      return TodoItem(
                        todo: todo,
                        onTodoChanged: _handleTodoChange,
                      );
                    }).toList(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
