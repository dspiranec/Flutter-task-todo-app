import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/login/Authenticate.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/widgets/common/Background.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/widgets/common/BtnOnClickCircularIndicator.dart';

class ClosedInfoScreen extends StatefulWidget {
  const ClosedInfoScreen({Key key}) : super(key: key);

  @override
  _ClosedInfoScreenState createState() => _ClosedInfoScreenState();
}

class _ClosedInfoScreenState extends State<ClosedInfoScreen> {
  Widget _button = Text(
    tr("ClosedInfoScreen.gumb"),
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontFamily: "Inter",
      fontWeight: FontWeight.w600,
    ),
  );

  _changeButtonToCircularProgressButton(double width, double height) {
    setState(() {
      _button = BtnOnClickCircularIndicator(width: 27, height: 27);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 335,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                        child: Text(
                          tr("ClosedInfoScreen.naslov"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          tr("ClosedInfoScreen.poruka"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff666666),
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
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
                            vertical: 18,
                          ),
                          child: _button,
                        ),
                        onTap: () {
                          _changeButtonToCircularProgressButton(27, 27);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Authenticate()),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
