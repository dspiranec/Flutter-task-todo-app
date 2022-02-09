import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/logic/service/AuthService.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/logic/service/UserService.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/login/Authenticate.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/widgets/common/Background.dart';

class InfoScreen extends StatefulWidget {
  final String userId;

  const InfoScreen({
    Key key,
    this.userId,
  }) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState(userId);
}

class _InfoScreenState extends State<InfoScreen> {
  final String _userId;
  bool _showLogOut;
  PackageInfo _packageInfo;
  String _environment;

  _InfoScreenState(this._userId);

  @override
  void initState() {
    super.initState();
    _shouldShowLogOutButton();
    _initPackageInfo();
  }

  _logout() async {
    await AuthService().removeDataFromLocalStorageAndUnsubcribeFCM();
  }

  _shouldShowLogOutButton() async {
    bool shouldShow = await UserService().isUserTester(_userId);
    setState(() {
      _showLogOut = shouldShow;
    });
  }

  _initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = packageInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showLogOut != null
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            body: _packageInfo == null && _environment == null
                ? Center(child: CircularProgressIndicator())
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      Background(),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, bottom: 10, top: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Expanded(child: Container()),
                                Expanded(
                                    child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    _environment == "test" ? "TEST" : "",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 34),
                                  ),
                                )),
                                _showLogOut
                                    ? Expanded(
                                        child: Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: IconButton(
                                            onPressed: () {
                                              {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(tr(
                                                          "InfoScreen.Odjava.potvrda")),
                                                      actions: [
                                                        TextButton(
                                                          child: Text("NE"),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text("DA"),
                                                          onPressed: () async {
                                                            await _logout();
                                                            Navigator
                                                                .pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          Authenticate()),
                                                              (route) => false,
                                                            );
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            icon: Icon(Icons.logout),
                                            color: Colors.white,
                                            iconSize: 50,
                                          ),
                                        ),
                                      ))
                                    : Expanded(
                                        child: SizedBox(height: 100),
                                      ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Image(
                                image: AssetImage(
                                    'lib/assets/icon/logo2BezPozadine.png'),
                                width: 150,
                                height: 150,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Task TODO App",
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontSize: 42,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                )),
                            Text(
                              _packageInfo.version,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 0.4),
                                  fontFamily: 'SF Compact Text',
                                  fontSize: 16,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 50),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            "ID: ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: "Inter",
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            _userId,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      tr("InfoScreen.copyright"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.4),
                                          fontFamily: 'SF Compact Text',
                                          fontSize: 16,
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ))
        : Background();
  }
}
