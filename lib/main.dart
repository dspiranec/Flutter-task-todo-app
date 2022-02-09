import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/logic/ValidateView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  Intl.defaultLocale = "hr_HR";
  runApp(
    EasyLocalization(
        child: TaskTodoApp(),
        supportedLocales: [
          Locale("hr", "HR"),
          Locale("en", "EN"),
        ],
        fallbackLocale: Locale("hr", "HR"),
        path: "resources/l10n"),
  );
}

class TaskTodoApp extends StatefulWidget {
  @override
  _TaskTodoAppState createState() => _TaskTodoAppState();
}

class _TaskTodoAppState extends State<TaskTodoApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      debugShowCheckedModeBanner: false,
      home: Container(
        color: Color.fromRGBO(0, 141, 220, 1),
        padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
        child: new SplashScreen(
          image: Image.asset(
            'lib/assets/icon/logo2BezPozadine.png',
            fit: BoxFit.contain,
          ),
          loadingText: Text(
            'Dominik Špiranec',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.4),
                fontFamily: 'SF Compact Text',
                fontSize: 16,
                letterSpacing: 1.5,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
          seconds: 3,
          navigateAfterSeconds: AfterSplash(),
          title: new Text(
            "Task TODO App",
            textAlign: TextAlign.center,
            style: new TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 42,
                letterSpacing: 1,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
          backgroundColor: Color.fromRGBO(0, 141, 220, 1),
          photoSize: 120,
          loaderColor: Colors.white,
          useLoader: false,
        ),
      ),
      theme: ThemeData(primaryColor: Color.fromRGBO(0, 141, 220, 1)),
    );
  }
}

class AfterSplash extends StatefulWidget {
  @override
  _AfterSplashState createState() => _AfterSplashState();
}

class _AfterSplashState extends State<AfterSplash> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValidateView();
  }
}
