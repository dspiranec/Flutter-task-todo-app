import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/forms/UnwantedEventScreen.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/widgets/screen/InfoScreen.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/widgets/screen/TodoScreen.dart';

class Home2 extends StatefulWidget {
  static int selectedIndex = 0;

  Home2({Key key}) : super(key: key);

  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static const Color _iconColor = Colors.grey;
  static const Color _activeIconColor = Color(0xff3baef0);
  String _userId;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getUserIdFromLocalStorage();
  }

  _getUserIdFromLocalStorage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      _userId = localStorage.getString('userId');
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Home2.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _getSelectedBody(_selectedIndex),
      bottomNavigationBar: SizedBox(
        height: 80.0,
        child: SingleChildScrollView(
          child: BottomNavigationBar(
            elevation: 0.0,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: 'Početna',
                icon: Icon(
                  Icons.home,
                  color: _iconColor,
                ),
                activeIcon: CircleAvatar(
                  radius: 24,
                  backgroundColor: _activeIconColor,
                  child: IconButton(
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    iconSize: 30,
                    onPressed: null,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Događaj',
                icon: Icon(
                  Icons.event_note_outlined,
                  color: _iconColor,
                ),
                activeIcon: CircleAvatar(
                  radius: 24,
                  backgroundColor: _activeIconColor,
                  child: IconButton(
                    icon: Icon(
                      Icons.event_note_outlined,
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
                  Icons.error_outline_rounded,
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
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: _activeIconColor,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  _getSelectedBody(int index) {
    if (_userId != null) {
      switch (index) {
        case 1:
          return UnwantedEventScreen(userId: _userId);
          break;
        case 2:
          return InfoScreen(userId: _userId);
          break;
        default:
          return TodoScreen(userId: _userId);
          break;
      }
    }
  }
}
