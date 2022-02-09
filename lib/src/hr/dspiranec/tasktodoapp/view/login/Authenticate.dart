
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/logic/ValidateView.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/logic/service/UserService.dart';

import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/widgets/common/Background.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/qr_scanner/QrScanner.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/model/User.dart';

import '../../logic/service/AuthService.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  String _userId = "";
  User _user;
  bool _userExists = true;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          return Stack(fit: StackFit.expand, children: <Widget>[
            Background(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Container(
                  width: 335,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            tr("Authenticate.naslov"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            tr("Authenticate.podnaslov"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff666666),
                              fontSize: 16,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        _userExists
                            ? SizedBox.shrink()
                            : Text(
                                tr("Authenticate.kodNePostoji"),
                                style:
                                    TextStyle(fontSize: 16, color: Colors.red),
                              ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Molim vas unesite kod";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _userId = value;
                              },
                              onSaved: (value) {
                                _userId = value;
                              },
                            ),
                          ),
                        ),
                        InkWell(
                          child: Container(
                            width: 311,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Color(0xff3baef0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            child: Text(
                              tr("Authenticate.loginButton"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          onTap: () async {
                            if (_formKey.currentState.validate()) {
                              await checkUserId(_userId, context);
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: TextButton(
                            child: Text(
                              tr("Authenticate.QRkod"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xff3baef0),
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _userExists = true;
                              });
                              _scanAndAuthenticate(context);
                            },
                          ),
                        )
                      ]),
                ),
                Expanded(child: Container()),
              ],
            )
          ]);
        },
      ),
    );
  }

  _scanAndAuthenticate(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QrScanner()),
    );
    if (result != null) {
      setState(() {
        _userId = result;
      });
      checkUserId(_userId, context);
    }
  }

  checkUserId(String userId, BuildContext context) async {
    bool flag = await checkIfUserExists(_userId);

    setState(() {
      _userExists = flag;
    });

    if (_userExists) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ValidateView()),
      );
    }
  }

  checkIfUserExists(String userId) async {
    bool userExists = await AuthService().checkIfUserByIdExists(userId);

    if (userExists) {
      _user = await UserService().getUserById(userId);
      if (_user.status != "closed") {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('isUserLoggedIn', 'true');
        prefs.setString('userId', _user.id);
        prefs.setString('role', _user.role);
        prefs.setString('status', _user.status);

        AuthService().checkIfUserFirstLogin(userId);
        return true;
      } else
        return false;
    } else
      return false;
  }
}
