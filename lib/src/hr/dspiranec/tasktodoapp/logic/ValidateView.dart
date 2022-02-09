import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/logic/service/AuthService.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/logic/service/UserService.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/login/Authenticate.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/profile/AdminHome.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/profile/UserHome.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/widgets/screen/ClosedInfoScreen.dart';

class ValidateView extends StatefulWidget {
  @override
  _ValidateViewState createState() => _ValidateViewState();
}

class _ValidateViewState extends State<ValidateView> {
  String _isUserLoggedIn;
  String _userRole;
  String _userStatus;
  String _userId;
  bool _dataCollected = false;

  @override
  void initState() {
    super.initState();
    updateAndCollectDataFromLocStorage();
  }

  updateAndCollectDataFromLocStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId');
    });

    await UserService().getUserById(_userId).then((user) => {
          if (user != null)
            {
              prefs.setString('role', user.role),
              prefs.setString('status', user.status),
            }
        });
    setState(() {
      _isUserLoggedIn = prefs.getString('isUserLoggedIn');
      _userRole = prefs.getString('role');
      _userStatus = prefs.getString('status');
      _userId = prefs.getString('userId');
      _dataCollected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_dataCollected) {
      if (_isUserLoggedIn == "true" && _userStatus != "closed") {
        if (_userRole == "admin") {
          return new WillPopScope(
              onWillPop: () async => false, child: new AdminHome());
        } else if (_userRole == "user") {
          return new WillPopScope(
              onWillPop: () async => false, child: new Home2());
        }
      } else if (_isUserLoggedIn == "false") {
        return Authenticate();
      } else if (_userStatus == "closed") {
        AuthService().removeDataFromLocalStorageAndUnsubcribeFCM();
        return ClosedInfoScreen();
      }
    } else {
      return Container(
          color: Color.fromRGBO(0, 141, 220, 1),
          child: Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          )));
    }
    return Authenticate();
  }
}
