import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/logic/service/UserService.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/model/User.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/profile/AdminHome.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/widgets/common/BtnOnClickCircularIndicator.dart';

class CreateNewUser extends StatefulWidget {
  @override
  _CreateNewUserState createState() => _CreateNewUserState();
}

class _CreateNewUserState extends State<CreateNewUser> {
  final _formKey = GlobalKey<FormState>();
  String _dropdownRoleValue = "user";
  String _userCode;
  bool _userCodeIsUnique;
  bool _showSpinner = false;

  Widget _okayButton = Text(
    tr("CreateNewUser.PodaciKreiranogKorisnika.gumbZaNazad"),
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontFamily: "Inter",
      fontWeight: FontWeight.w600,
    ),
  );

  Widget _createUserButton = Text(
  tr("CreateNewUser.gumbKreiraj"),
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontFamily: "Inter",
      fontWeight: FontWeight.w600,
    ),
  );

  _changeOkayButtonToCircularProgressButton(double width, double height) {
    setState(() {
      _okayButton = BtnOnClickCircularIndicator(width: width, height: height);
    });
  }

  _changeCreateNewUserButtonToCircularProgressButton(
      double width, double height) {
    setState(() {
      _createUserButton =
          BtnOnClickCircularIndicator(width: width, height: height);
    });
  }

  _returnButtonToDefaultState() {
    setState(() {
      _createUserButton = Text(
        "Kreiraj korisnika",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontFamily: "Inter",
          fontWeight: FontWeight.w600,
        ),
      );
    });
  }

  _createNewUser(String userCode, String userRole) async {
    await UserService().createUser(userCode, userRole);
  }

  _isCodeUnique(String code) async {
    bool isUnique = await UserService().checkIfUserCodeIsUnique(code);
    setState(() {
      _userCodeIsUnique = isUnique;
    });
  }

  displayCreatedUser(String userId, String createdAt) {
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
                          data: userId,
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
                                  text: userId ?? "",
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
                                  text: createdAt,
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
                          child: _okayButton,
                        ),
                        onTap: () {
                          _changeOkayButtonToCircularProgressButton(27, 27);
                          Navigator.of(context).pop();
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
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            tr("CreateNewUser.naslov"),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: _showSpinner == true
          ? Column(
              children: [
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ],
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Form(
                  key: _formKey,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x3f252382),
                          blurRadius: 20,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    height: MediaQuery.of(context).size.height * 0.58,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 2,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 10, top: 20, right: 10, bottom: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _userCodeIsUnique == null ||
                                      _userCodeIsUnique == true
                                  ? SizedBox.shrink()
                                  : Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        "Šifra korisnika već postoji",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.red),
                                      )),
                              _dropdownRoleValue == "admin"
                                  ? SizedBox.shrink()
                                  : Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Color(0x19adadad),
                                        border: Border.all(
                                          color: Color(0xffc2c2c2),
                                          width: 2,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 4,
                                      ),
                                      child: TextFormField(
                                        initialValue: _userCode,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Šifra korisnika",
                                          hintStyle: TextStyle(
                                            color: Color(0xff828282),
                                            fontSize: 24,
                                            fontFamily: "Inter",
                                          ),
                                        ),
                                        validator: (value) {
                                          //Makni validaciju za unique šifru ukoliko je textfield prazan
                                          if (value.isEmpty) {
                                            setState(() {
                                              _userCodeIsUnique = true;
                                            });
                                            return 'Unesite šifru korisnika';
                                          }

                                          return null;
                                        },
                                        onChanged: (String newValue) {
                                          setState(() {
                                            _userCode = newValue;
                                          });
                                        },
                                      ),
                                    ),
                              Padding(
                                padding: EdgeInsets.only(top: 15.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Color(0x19adadad),
                                    border: Border.all(
                                      color: Color(0xffc2c2c2),
                                      width: 2,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 4,
                                  ),
                                  child: DropdownButton<String>(
                                    value: _dropdownRoleValue,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    isExpanded: true,
                                    style: TextStyle(
                                      color: Color(0xff828282),
                                      fontSize: 24.0,
                                      fontFamily: "Inter",
                                    ),
                                    underline: SizedBox(),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _dropdownRoleValue = newValue;
                                      });
                                    },
                                    items: <String>['user', 'admin']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 4,
                                  ),
                                  child: InkWell(
                                      child: Container(
                                        width: 335,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Color(0xff3baef0),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 18,
                                        ),
                                        child: _createUserButton,
                                      ),
                                      onTap: () async {
                                        _changeCreateNewUserButtonToCircularProgressButton(
                                            37, 37);
                                        FocusScope.of(context).unfocus();
                                        if (_formKey.currentState.validate()) {
                                          if (_dropdownRoleValue == "admin") {
                                            setState(() {
                                              _userCode =
                                                  "admin"; //defaultna vrijednost šifre svakog admina
                                              _userCodeIsUnique = true;
                                            });
                                          } else {
                                            await _isCodeUnique(_userCode);
                                          }
                                          if (_userCodeIsUnique) {
                                            setState(() {
                                              _showSpinner = true;
                                            });

                                            await _createNewUser(
                                                _userCode,
                                                _dropdownRoleValue);

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminHome.fromScreen(
                                                        navigationIndex: 0),
                                              ),
                                            );

                                            User createdUser =
                                                await UserService()
                                                    .getUserByCode(_userCode);

                                            var formatter =
                                                new DateFormat('dd.MM.yyyy.');
                                            String createdUserDate = formatter
                                                .format(createdUser.createdAt);

                                            setState(() {
                                              _showSpinner = false;
                                            });
                                            displayCreatedUser(createdUser.id,
                                                createdUserDate);
                                          }
                                        } else {
                                          _returnButtonToDefaultState();
                                        }
                                      }),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15.0),
                                child: InkWell(
                                    child: Container(
                                      width: 311,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Color(0xffc2c2c2),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 16,
                                      ),
                                      child: Text(
                                        tr("CreateNewUser.gumbOdustani"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
