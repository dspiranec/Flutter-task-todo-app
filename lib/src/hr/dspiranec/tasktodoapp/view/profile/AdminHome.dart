import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/forms/CreateTodoScreen.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/widgets/screen/DeactivatedUsersScreen.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/widgets/screen/InfoScreen.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/widgets/screen/UnwantedEventsScreen.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/widgets/screen/UsersScreen.dart';

class AdminHome extends StatefulWidget {
  int navigationIndex = 2;

  AdminHome.fromScreen({
    this.navigationIndex,
  });

  AdminHome();

  @override
  AdminHomeState createState() => AdminHomeState(navigationIndex);
}

class AdminHomeState extends State<AdminHome> {
  int _selectedIndex;
  String _userId;
  static const Color _iconColor = Colors.grey;
  static const Color _activeIconColor = Color(0xff3baef0);
  static var showBadge = ValueNotifier<bool>(false);

  AdminHomeState(this._selectedIndex);

  AdminHomeState.forNotification();

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  showIncidentNotificationBadge() {
    if (_selectedIndex == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UnwantedEventsScreen(),
          ));
    } else {
      showBadge.value = true;
    }
  }

  hideBadge() {
    showBadge.value = false;
  }

  _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId');
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) hideBadge();
  }

  _getSelectedBody(int index) {
    switch (index) {
      case 0:
        return UsersScreen();
        break;
      case 1:
        return UnwantedEventsScreen();
        break;
      case 2:
        return CreateTodoScreen();
        break;
      case 3:
        if (_userId != null) return InfoScreen(userId: _userId);
        break;
      case 4:
        return DeactivatedUsersScreen();
      default:
        return CreateTodoScreen();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedBody(_selectedIndex),
      bottomNavigationBar: SizedBox(
        height: 80.0,
        child: SingleChildScrollView(
          child: BottomNavigationBar(
            elevation: 0.0,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: 'Korisnici',
                icon: Icon(
                  Icons.perm_identity,
                  color: _iconColor,
                ),
                activeIcon: CircleAvatar(
                  radius: 24,
                  backgroundColor: _activeIconColor,
                  child: IconButton(
                    icon: Icon(
                      Icons.perm_identity,
                      color: Colors.white,
                    ),
                    iconSize: 30,
                    onPressed: null,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Događaji',
                icon: Stack(children: <Widget>[
                  Icon(
                    Icons.bar_chart_rounded,
                    color: _iconColor,
                  ),
                  ValueListenableBuilder(
                    valueListenable: showBadge,
                    builder: (context, value, widget) {
                      return Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: showBadge.value
                            ? Icon(Icons.brightness_1,
                                size: 12.0, color: Colors.redAccent)
                            : SizedBox.shrink(),
                      );
                    },
                  ),
                ]),
                activeIcon: CircleAvatar(
                  radius: 24,
                  backgroundColor: _activeIconColor,
                  child: IconButton(
                    icon: Icon(
                      Icons.bar_chart_rounded,
                      color: Colors.white,
                    ),
                    iconSize: 30,
                    onPressed: hideBadge,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: 'TODO',
                icon: Icon(
                  Icons.event_available_outlined,
                  color: _iconColor,
                ),
                activeIcon: CircleAvatar(
                  radius: 24,
                  backgroundColor: _activeIconColor,
                  child: IconButton(
                    icon: Icon(
                      Icons.event_available_outlined,
                      color: Colors.white,
                    ),
                    iconSize: 30,
                    onPressed: null,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Info',
                icon: Icon(
                  Icons.info_outline_rounded,
                  color: _iconColor,
                ),
                activeIcon: CircleAvatar(
                  radius: 24,
                  backgroundColor: _activeIconColor,
                  child: IconButton(
                    icon: Icon(
                      Icons.info_outline_rounded,
                      color: Colors.white,
                    ),
                    iconSize: 30,
                    onPressed: null,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Deaktivirani',
                icon: Icon(
                  Icons.perm_identity,
                  color: _iconColor,
                ),
                activeIcon: CircleAvatar(
                  radius: 24,
                  backgroundColor: _activeIconColor,
                  child: IconButton(
                    icon: Icon(
                      Icons.perm_identity,
                      color: Colors.white,
                    ),
                    iconSize: 30,
                    onPressed: null,
                  ),
                ),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: _activeIconColor,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
