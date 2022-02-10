import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/logic/service/IncidentService.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/widgets/common/Background.dart';

class UnwantedEventScreen extends StatefulWidget {
  final String userId;

  const UnwantedEventScreen({
    Key key,
    this.userId,
  }) : super(key: key);

  @override
  _UnwantedEventScreenState createState() => _UnwantedEventScreenState(userId);
}

class _UnwantedEventScreenState extends State<UnwantedEventScreen> {
  final String _userId;
  bool _validator = true;
  int _selectedAlertReasonRadioButton;
  String _reasonWhyTextField;

  List<String> _alertReasons = [
    "undifined",
    "Nisam dobio TODO listu",
    "Bug unutar aplikacije",
    "Nepredviđeno ponašanje aplikacije",
    "ostalo"
  ];

  _UnwantedEventScreenState(this._userId);

  @override
  void initState() {
    super.initState();
  }

  _setSelectedAlertReasonRadioButton(int value) {
    setState(() {
      _selectedAlertReasonRadioButton = value;
    });
  }

  _saveUnwantedEvent() async {
    await IncidentService().addUnwantedEvent(_userId,
        _alertReasons[_selectedAlertReasonRadioButton], _reasonWhyTextField);
  }

  _resetForm() {
    setState(() {
      _selectedAlertReasonRadioButton = 0;
      _reasonWhyTextField = "";
    });
  }

  _alertValidator() {
    bool flag;

    //Nije oznacen razlog vjezbanja
    if (_selectedAlertReasonRadioButton == null)
      flag = false;
    //Nije napisan razlog zasto
    else if (_selectedAlertReasonRadioButton == 4 &&
        _reasonWhyTextField == null)
      flag = false;
    else
      flag = true;

    setState(() {
      _validator = flag;
    });

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(fit: StackFit.expand, children: [
          Background(),
Center(
  child:           SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: 10, right: 10, bottom: 30, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: 20.0, top: 20.0, right: 20.0),
                  child: Text(
                    "Prijava neželjenog događaja",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _validator
                    ? SizedBox.shrink()
                    : Text(
                  "Označite jedan od ponuđenih odgovora",
                  style:
                  TextStyle(fontSize: 14, color: Colors.red),
                ),
                Divider(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "1. Nisam dobio TODO listu",
                        style: TextStyle(
                          color: Color(0xff828282),
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Radio(
                        value: 1,
                        groupValue: _selectedAlertReasonRadioButton,
                        onChanged: (val) {
                          _setSelectedAlertReasonRadioButton(val);
                        }),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "2. Bug unutar aplikacije",
                        style: TextStyle(
                          color: Color(0xff828282),
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Radio(
                        value: 2,
                        groupValue: _selectedAlertReasonRadioButton,
                        onChanged: (val) {
                          _setSelectedAlertReasonRadioButton(val);
                        }),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "3. Nepredviđeno ponašanje aplikacije",
                        style: TextStyle(
                          color: Color(0xff828282),
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Radio(
                        value: 3,
                        groupValue: _selectedAlertReasonRadioButton,
                        onChanged: (val) {
                          _setSelectedAlertReasonRadioButton(val);
                        }),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "4. Ostalo",
                        style: TextStyle(
                          color: Color(0xff828282),
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Radio(
                        value: 4,
                        groupValue: _selectedAlertReasonRadioButton,
                        onChanged: (val) {
                          _setSelectedAlertReasonRadioButton(val);
                        }),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _selectedAlertReasonRadioButton == 4
                          ? TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Navedite drugi razlog',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _reasonWhyTextField = value;
                          });
                        },
                      )
                          : SizedBox.shrink(),
                    )
                  ],
                ),
                Divider(
                  height: 10.0,
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
                      "Prijavi",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () {
                    _alertValidator();
                    if (_validator) {
                      _saveUnwantedEvent();
                      FocusScope.of(context).unfocus();
                      _resetForm();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Prijava uspješna"),
                            content: Text(
                                "Kontaktirat ćemo Vas u roku 24 sata po prijavi."),
                            actions: <Widget>[
                              TextButton(
                                child: Text('U redu'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
),
        ]));
  }
}
