import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/model/Todo.dart';

class TodoService {
  CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("users");

  TodoService();

  getTodoListByUserId(String userId) async {
    List<dynamic> dynamicTodos = <Todo>[];
    await _usersRef.doc(userId).get().then((user) {
      Map<String, dynamic> userMap = user.data();
      if (userMap.containsKey('todos')) {
        dynamicTodos = [...userMap["todos"]];
      }
    });

    List<Todo> todos = <Todo>[];
    dynamicTodos.forEach((element) {
      Todo todo = new Todo();
      todo.name = element["name"];
      todo.checked = element["checked"];
      todos.add(todo);
    });
    return todos;
  }

  syncTodoToAllUsers(List<Todo> todos) async {
    List myTodos = [];
    todos.forEach((todo) {
      myTodos.add({"name": todo.name, "checked": false});
    });

    QuerySnapshot qSnapshot = await _usersRef
        .where("role", isEqualTo: "user")
        .where("status", whereIn: ["active", "created"]).get();

    await qSnapshot.docs.forEach((user) =>
        _usersRef.doc(user.id).update({'todos': FieldValue.delete()}));
    await qSnapshot.docs.forEach((user) => _usersRef
        .doc(user.id)
        .update({'todos': FieldValue.arrayUnion(myTodos)}));
  }

  updateTodoListWithUserId(String userId, List<Todo> todos) async {
    _usersRef.doc(userId).update({'todos': FieldValue.delete()});

    List myTodos = [];
    todos.forEach((todo) {
      myTodos.add({"name": todo.name, "checked": todo.checked});
    });

    _usersRef.doc(userId).update({'todos': FieldValue.arrayUnion(myTodos)});
  }
/*
  Future<void> closeCurrentFilledSurvey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId');

    _usersRef.doc(userId).update({'inactiveDays': 0});
    _surveyeesRef.doc(_surveyId).update({'status': 'filled'});
    _surveyeesRef.doc(_surveyId).update({'filledAt': DateTime.now()});
  }

  createSurveyForUserId(String userId) async {
    if (DateTime.now().hour >= 19) {
      await _surveyeesRef.add(
          {'status': 'active', 'createdAt': DateTime.now(), 'userId': userId});
    } else {
      await _surveyeesRef.add({
        'status': 'active',
        'createdAt': DateTime.now().subtract(Duration(days: 1)),
        'userId': userId
      });
    }
  }

  getAllSurveyees() async {
    QuerySnapshot qSnapshot = await _surveyeesRef.get();
    List<QueryDocumentSnapshot> surveyDocs = qSnapshot.docs;
    List<Survey> surveyees = [];

    surveyDocs.forEach((survey) => {
          if (survey.exists)
            surveyees.add(Survey.fromJson(survey.data(), survey.id))
        });
    return surveyees;
  }

  getAllSurveyeesFromUserIdWithin30Days(String userId) async {
    final numberOfDays = DateTime.now().subtract(Duration(days: 30));
    QuerySnapshot withinNumberOfDays = await _surveyeesRef
        .where('createdAt', isGreaterThan: numberOfDays)
        .get();
    List<QueryDocumentSnapshot> surveyDocs = withinNumberOfDays.docs;

    final usersSurveyees =
        surveyDocs.where((survey) => survey.get('userId') == userId);
    List<Survey> surveyees = [];

    usersSurveyees.forEach((survey) => {
          if (survey.exists)
            surveyees.add(Survey.fromJson(survey.data(), survey.id))
        });
    return surveyees;
  }

  getCountOfAllSurveyeesWithin7Days() async {
    final numberOfDays = DateTime.now().subtract(Duration(days: 7));
    QuerySnapshot withinNumberOfDays = await _surveyeesRef
        .where('createdAt', isGreaterThan: numberOfDays)
        .get();

    return withinNumberOfDays.docs.length;
  }
  */
}
