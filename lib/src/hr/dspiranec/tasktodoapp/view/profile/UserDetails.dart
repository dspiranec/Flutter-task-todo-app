import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/logic/service/UserService.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/model/User.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/profile/AdminHome.dart';

class UserDetails extends StatefulWidget {
  final User user;

  UserDetails(this.user);

  @override
  _UserDetailsState createState() => _UserDetailsState(user);
}

class _UserDetailsState extends State<UserDetails>
    with TickerProviderStateMixin {
  TabController _tabController;
  User _user;

  _UserDetailsState(this._user);

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  displayCreatedUser(User user, DateTime createdAt) {
    final String date = createdAt.day.toString() +
        "." +
        createdAt.month.toString() +
        "." +
        createdAt.year.toString() +
        ".";
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Center(
                child: Text(
                  tr("CreateNewUser.PodaciKreiranogKorisnika.naslov"),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            body: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                side: BorderSide(
                  color: Colors.grey,
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        child: QrImage(
                          data: _user.id,
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 5.0, top: 25.0, right: 5.0),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      tr("CreateNewUser.PodaciKreiranogKorisnika.ID") +
                                          " - ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: _user.id ?? "",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      tr("CreateNewUser.PodaciKreiranogKorisnika.kreirano") +
                                          " - ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: date,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: InkWell(
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
                            tr("CreateNewUser.PodaciKreiranogKorisnika.gumbZaNazad"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          /*
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDetails(user),
                              ));*/
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Row(
            children: [
              Container(
                child: Text(
                  tr("UserDetails.naslov"),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  _user.code,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Color(0xff3baef0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40), // <-- Radius
                    )),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    tr("CreateNewUser.PopupMenuButton.detalji"),
                    style: TextStyle(fontSize: 28, color: Colors.white),
                  ),
                ),
                onPressed: () async {
                  await /*_userInfoPopUp(context)*/ displayCreatedUser(
                      _user, _user.createdAt);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Color(0xff3baef0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40), // <-- Radius
                    )),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    tr("CreateNewUser.PopupMenuButton.Deaktivacija.naslov"),
                    style: TextStyle(fontSize: 28, color: Colors.white),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(tr(
                            "CreateNewUser.PopupMenuButton.Deaktivacija.alertDialog")),
                        actions: [
                          TextButton(
                            child: Text("NE"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("DA"),
                            onPressed: () async {
                              await UserService()
                                  .changeUserStatusToClosed(_user.id);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminHome.fromScreen(navigationIndex: 4)
                                  ));
                            },
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(child: Container()),
          ],
        ));
  }
}
