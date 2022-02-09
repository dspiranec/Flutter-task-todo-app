import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/logic/service/UserService.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/model/User.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/forms/CreateNewUser.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/profile/UserDetails.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/widgets/common/DataNotFound.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User> _activeUsers;
  List<User> _filteredActiveUsers;
  bool _activeUsersDataIsEmpty = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getAllActiveAndCreatedUsers();
  }

  _onSearchChanged() {
    _filterActiveResults();
  }

  _filterActiveResults() {
    List<User> results = [];

    if (_searchController.text != "") {
      _activeUsers.forEach((user) {
        if (user.code
            .toLowerCase()
            .contains(_searchController.text.toLowerCase())) {
          results.add(user);
        }
      });
    } else {
      results = _activeUsers;
    }

    setState(() {
      _filteredActiveUsers = results;
    });
  }

  _getAllActiveAndCreatedUsers() async {
    List users =
        await UserService().getAllActiveAndCreatedUsersOrderedByInactiveDays();

    setState(() {
      _activeUsers = users;
      if (users.isEmpty)
        _activeUsersDataIsEmpty = true;
      else
        _activeUsersDataIsEmpty = false;
    });

    _filterActiveResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            tr("AdminHome.naslov"),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () => _searchController.clear(),
                    icon: Icon(Icons.clear),
                  ),
                  hintText: "Šifra korisnika"),
            ),
          ),
          Expanded(
              flex: 5,
              child: !_activeUsersDataIsEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          child: Expanded(
                            child: _filteredActiveUsers == null
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: _filteredActiveUsers != null
                                        ? _filteredActiveUsers.length
                                        : 0,
                                    itemBuilder: (context, index) {
                                      User user = _filteredActiveUsers[index];
                                      return Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              width: 2.0,
                                              color: Color.fromRGBO(
                                                  224, 224, 224, 1),
                                            ),
                                          ),
                                        ),
                                        child: FlatButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserDetails(user)),
                                              );
                                            },
                                            splashColor:
                                                Color.fromRGBO(59, 174, 240, 1),
                                            child: ListTile(
                                              contentPadding:
                                                  EdgeInsets.all(5.0),
                                              leading: Icon(
                                                Icons.radio_button_on,
                                                size: 24,
                                                color: Colors.green,
                                              ),
                                              title: Row(
                                                children: [
                                                  Text(
                                                    "Šifra: ",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  Text(
                                                    user.code,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 5, bottom: 5),
                                                child: Text(
                                                  "ID: " + user.id,
                                                  // overflow: TextOverflow.fade,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            )),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    )
                  : DataNotFound(title: "Nema podataka")),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only(top: 15.0, right: 10.0, bottom: 15.0),
          child: FloatingActionButton(
              backgroundColor: Color.fromRGBO(59, 174, 240, 1),
              child: Text(
                tr("AdminHome.kreirajKorisnika"),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 38.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateNewUser()),
                );
              }),
        ),
      ),
    );
  }
}
