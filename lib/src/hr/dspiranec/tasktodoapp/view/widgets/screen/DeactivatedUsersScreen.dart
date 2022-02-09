import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/logic/service/UserService.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/model/User.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/profile/UserDetails.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/widgets/common/DataNotFound.dart';

class DeactivatedUsersScreen extends StatefulWidget {
  @override
  _DeactivatedUsersScreenState createState() => _DeactivatedUsersScreenState();
}

class _DeactivatedUsersScreenState extends State<DeactivatedUsersScreen> {
  List<User> _deactivatedUsers;
  List<User> _filteredDeactivatedUsers;
  bool _deactivatedUsersDataIsEmpty = false;
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
    _getAllDeactivatedUsers();
  }

  _onSearchChanged() {
    _filterDeactivatedResults();
  }

  _filterDeactivatedResults() {
    List<User> results = [];

    if (_searchController.text != "") {
      _deactivatedUsers.forEach((user) {
        if (user.code
            .toLowerCase()
            .contains(_searchController.text.toLowerCase())) {
          results.add(user);
        }
      });
    } else {
      results = _deactivatedUsers;
    }

    setState(() {
      _filteredDeactivatedUsers = results;
    });
  }

  _getAllDeactivatedUsers() async {
    List users =
        await UserService().getAllDeactivatedUsersOrderedByInactiveDays();

    setState(() {
      _deactivatedUsers = users;
      if (users.isEmpty)
        _deactivatedUsersDataIsEmpty = true;
      else
        _deactivatedUsersDataIsEmpty = false;
    });

    _filterDeactivatedResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            tr("AdminHome.deaktiviraniNaslov"),
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
              child: !_deactivatedUsersDataIsEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          child: Expanded(
                            child: _filteredDeactivatedUsers == null
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: _filteredDeactivatedUsers != null
                                        ? _filteredDeactivatedUsers.length
                                        : 0,
                                    itemBuilder: (context, index) {
                                      User user =
                                          _filteredDeactivatedUsers[index];
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
                                                size: 18,
                                                color: Colors.grey,
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
                                              subtitle: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                bottom: 5),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "ID: " + user.id,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 18),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
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
    );
  }
}
