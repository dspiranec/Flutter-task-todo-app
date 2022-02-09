import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/model/User.dart';

import 'UserService.dart';

class AuthService {
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  checkIfUserByIdExists(String userId) async {
    User user = await UserService().getUserById(userId);
    if (user != null)
      return true;
    else
      return false;
  }

  checkIfUserFirstLogin(String userId) async {
    DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();

    if (userSnapshot.get('status') == 'created') {
      usersRef.doc(userId).update({'status': 'active'});
    }
  }

  removeDataFromLocalStorageAndUnsubcribeFCM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('isUserLoggedIn', 'false');
    prefs.remove('userId');
    prefs.remove('role');
    prefs.remove('status');
  }
}
