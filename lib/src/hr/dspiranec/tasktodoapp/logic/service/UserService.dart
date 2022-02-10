import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/model/User.dart';

class UserService {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference surveyeesRef =
      FirebaseFirestore.instance.collection("surveyees");
  final CollectionReference notificationsRef =
      FirebaseFirestore.instance.collection("notifications");
  final CollectionReference incidentsRef =
      FirebaseFirestore.instance.collection("incidents");

  changeUserStatusToClosed(String userId) async {
    await usersRef.doc(userId).update({'status': 'closed'});
  }

  isUserTester(String userId) async {
    return await usersRef.doc(userId).get().then((user) {
      Map<String, dynamic> userMap = user.data();
      if (userMap.containsKey('test') && userMap["test"] == true) return true;
      return false;
    });
  }

  getCountWorkoutsIn7Days(String userId) async {
    final numberOfDays = DateTime.now().subtract(Duration(days: 7));
    int countWorkout = 0;

    await surveyeesRef
        .where("userId", isEqualTo: userId)
        .where("status", isEqualTo: "filled")
        .where("createdAt", isGreaterThan: numberOfDays)
        .get()
        .then((snapshot) => snapshot.docs.forEach((survey) {
              String didWorkout =
                  survey.get("surveyAnswers.workoutScreen.workout");
              if (didWorkout == "da") ++countWorkout;
            }));

    return countWorkout;
  }

  Future<List<User>> getAllActiveAndCreatedUsersOrderedByInactiveDays() async {
    QuerySnapshot qSnapshot = await usersRef
        .where("role", isEqualTo: "user")
        .where("status", whereIn: ["active", "created"]).get();
    List<QueryDocumentSnapshot> userDocs = qSnapshot.docs;
    List<User> users = [];
    userDocs
        .forEach((user) => {users.add(User.fromJson(user.data(), user.id))});

    return users;
  }

  Future<List<User>> getAllDeactivatedUsersOrderedByInactiveDays() async {
    QuerySnapshot qSnapshot = await usersRef
        .where("role", isEqualTo: "user")
        .where("status", isEqualTo: "closed")
        .get();
    List<QueryDocumentSnapshot> userDocs = qSnapshot.docs;
    List<User> users = [];
    userDocs
        .forEach((user) => {users.add(User.fromJson(user.data(), user.id))});

    return users;
  }

  getUserById(String userId) async {
    DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();
    if (userSnapshot.exists)
      return new User.fromJson(userSnapshot.data(), userSnapshot.id);
  }

  checkIfUserCodeIsUnique(String userCode) async {
    QuerySnapshot user =
        await usersRef.where('code', isEqualTo: userCode).get();
    if (user.docs.isEmpty)
      return true;
    else
      return false;
  }

  getUserByCode(String userCode) async {
    QuerySnapshot snapshot =
        await usersRef.where('code', isEqualTo: userCode).get();
    if (snapshot.docs.isNotEmpty) {
      return User.fromJson(snapshot.docs.first.data(), snapshot.docs.first.id);
    }
  }

  createUser(String userCode, String userRole) async {
    await usersRef.add({
      'status': 'created',
      'createdAt': Timestamp.now(),
      'role': userRole,
      'code': userCode,
      'test': true
    });
  }
}
