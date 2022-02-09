import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SurveyService {/*
  String _surveyId;

  CollectionReference _surveyeesRef =
      FirebaseFirestore.instance.collection("surveyees");

  CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("users");

  SurveyService();

  SurveyService.bySurveyId(this._surveyId);

  Future<void> closeCurrentFilledSurvey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId');

    _usersRef.doc(userId).update({'inactiveDays': 0});
    _surveyeesRef.doc(_surveyId).update({'status': 'filled'});
    _surveyeesRef.doc(_surveyId).update({'filledAt': DateTime.now()});
  }

  createSurveyForUserId(String userId) async {
    if (DateTime.now().hour >= 19) {
      await _surveyeesRef.add(
          {'status': 'active', 'createdAt': DateTime.now(), 'userId': userId});
    } else {
      await _surveyeesRef.add({
        'status': 'active',
        'createdAt': DateTime.now().subtract(Duration(days: 1)),
        'userId': userId
      });
    }
  }

  getAllSurveyees() async {
    QuerySnapshot qSnapshot = await _surveyeesRef.get();
    List<QueryDocumentSnapshot> surveyDocs = qSnapshot.docs;
    List<Survey> surveyees = [];

    surveyDocs.forEach((survey) => {
          if (survey.exists)
            surveyees.add(Survey.fromJson(survey.data(), survey.id))
        });
    return surveyees;
  }

  getPainkillerUsageFromUserIdWithin30DaysGroupedByDays(String userId) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final DateTime currDate = DateTime.now();
    final DateTime lastDay =
        DateTime.utc(currDate.year, currDate.month, currDate.day)
            .subtract(Duration(days: 30));

    final month = [
      for (var i = 0; i < 30; ++i)
        DateTime.utc(currDate.year, currDate.month, currDate.day)
            .subtract(Duration(days: i))
    ];

    final Map<DateTime, List<dynamic>> monthMap = {};
    for (int i = 0; i < month.length; i++) {
      monthMap[month[i]] = [];
    }

    await _surveyeesRef
        .where("userId", isEqualTo: userId)
        .where("createdAt", isGreaterThan: lastDay)
        .where("status", isEqualTo: "filled")
        .get()
        .then((snapshot) => snapshot.docs.forEach((survey) {
              DateTime dbDate = survey.get("createdAt").toDate();
              String formattedDateDB = formatter.format(dbDate);

              for (var date in monthMap.keys) {
                String formattedDateMap = formatter.format(date);
                if (formattedDateMap == formattedDateDB &&
                    survey.get(
                            "surveyAnswers.painkillersScreen.painkillerTaken") ==
                        "da") {
                  monthMap[date] = survey
                      .get("surveyAnswers.painkillersScreen")
                      .keys
                      .where((element) => element != "painkillerTaken")
                      .toList();
                }
              }
            }));

    return monthMap;
  }

  getAllSurveyeesFromUserIdWithin30Days(String userId) async {
    final numberOfDays = DateTime.now().subtract(Duration(days: 30));
    QuerySnapshot withinNumberOfDays = await _surveyeesRef
        .where('createdAt', isGreaterThan: numberOfDays)
        .get();
    List<QueryDocumentSnapshot> surveyDocs = withinNumberOfDays.docs;

    final usersSurveyees =
        surveyDocs.where((survey) => survey.get('userId') == userId);
    List<Survey> surveyees = [];

    usersSurveyees.forEach((survey) => {
          if (survey.exists)
            surveyees.add(Survey.fromJson(survey.data(), survey.id))
        });
    return surveyees;
  }

  getCountOfAllSurveyeesWithin7Days() async {
    final numberOfDays = DateTime.now().subtract(Duration(days: 7));
    QuerySnapshot withinNumberOfDays = await _surveyeesRef
        .where('createdAt', isGreaterThan: numberOfDays)
        .get();

    return withinNumberOfDays.docs.length;
  }

  getCountOfAllFilledSurveyeesWithin7Days() async {
    final numberOfDays = DateTime.now().subtract(Duration(days: 7));
    QuerySnapshot withinNumberOfDays = await _surveyeesRef
        .where('createdAt', isGreaterThan: numberOfDays)
        .get();
    List<QueryDocumentSnapshot> surveyDocs = withinNumberOfDays.docs;

    final filledSurveyees =
        surveyDocs.where((survey) => survey.get('status') == 'filled');

    return filledSurveyees.length;
  }

  getAllFilledSurveyeesGroupedByDayWithin7Days() async {
    final week = [
      for (var i = 0; i <= 7; ++i) DateTime.now().subtract(Duration(days: i)),
    ];

    final Map<String, int> lastWeek = {};
    for (int i = 0; i < week.length; i++) {
      String key = week[i].day.toString() +
          "." +
          week[i].month.toString() +
          "." +
          week[i].year.toString() +
          ".";
      lastWeek[key] = 0;
    }

    final numberOfDays = DateTime.now().subtract(Duration(days: 7));
    await _surveyeesRef
        .where('createdAt', isGreaterThan: numberOfDays)
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              String day = element.get('createdAt').toDate().day.toString();
              String month = element.get('createdAt').toDate().month.toString();
              String year = element.get('createdAt').toDate().year.toString();

              String dateFromDB = day + "." + month + "." + year + ".";
              if (lastWeek.containsKey(dateFromDB) &&
                  element.get('status') == 'filled') {
                lastWeek[dateFromDB] += 1;
              }
            }));

    return lastWeek;
  }

  getAllSurveyeesGroupedByDayWithin7Days() async {
    final week = [
      for (var i = 0; i <= 7; ++i) DateTime.now().subtract(Duration(days: i)),
    ];

    final Map<String, int> lastWeek = {};
    for (int i = 0; i < week.length; i++) {
      String key = week[i].day.toString() +
          "." +
          week[i].month.toString() +
          "." +
          week[i].year.toString() +
          ".";
      lastWeek[key] = 0;
    }

    final numberOfDays = DateTime.now().subtract(Duration(days: 7));
    await _surveyeesRef
        .where('createdAt', isGreaterThan: numberOfDays)
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              String day = element.get('createdAt').toDate().day.toString();
              String month = element.get('createdAt').toDate().month.toString();
              String year = element.get('createdAt').toDate().year.toString();

              String dateFromDB = day + "." + month + "." + year + ".";
              if (lastWeek.containsKey(dateFromDB)) {
                lastWeek[dateFromDB] += 1;
              }
            }));
    return lastWeek;
  }

  Future<List<Survey>> getAllActiveSurveyeesFromCurrUser(String userId) async {
    List<Survey> surveyees = [];

    await _surveyeesRef
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: "active")
        .get()
        .then((snapshot) => snapshot.docs.forEach((survey) {
              if (survey.exists)
                surveyees.add(Survey.fromJson(survey.data(), survey.id));
            }));

    return surveyees;
  }

  void updateSymptoms(int symptoms, bool headache, bool muscleTension,
      bool handsTingle, bool sleepingProblems) {
    String haveSymptoms = symptoms == 1 ? "yes" : "no";
    if (haveSymptoms == "yes") {
      _surveyeesRef.doc(_surveyId).update({
        'surveyAnswers.symptomsScreen.symptoms': 'da',
        'surveyAnswers.symptomsScreen.headache':
            headache ? 'da' : FieldValue.delete(),
        'surveyAnswers.symptomsScreen.muscleTension':
            muscleTension ? 'da' : FieldValue.delete(),
        'surveyAnswers.symptomsScreen.handsTingle':
            handsTingle ? 'da' : FieldValue.delete(),
        'surveyAnswers.symptomsScreen.sleepingProblems':
            sleepingProblems ? 'da' : FieldValue.delete(),
      });
    } else if (haveSymptoms == "no") {
      _surveyeesRef.doc(_surveyId).update({
        'surveyAnswers.symptomsScreen.symptoms': 'ne',
        'surveyAnswers.symptomsScreen.headache': FieldValue.delete(),
        'surveyAnswers.symptomsScreen.muscleTension': FieldValue.delete(),
        'surveyAnswers.symptomsScreen.handsTingle': FieldValue.delete(),
        'surveyAnswers.symptomsScreen.sleepingProblems': FieldValue.delete(),
      });
    }
  }

  void updateAveragePain(int painValue) {
    _surveyeesRef.doc(_surveyId).update({
      'surveyAnswers.averagePainScreen.painIndicator': painValue,
    });
  }

  void updatePainkillers(
      int painKillerTaken,
      bool paracetamol,
      bool NSAR,
      bool tramadol,
      bool tramadolAndParacetamol,
      bool tramadolAndDeksketoprofen,
      bool diazepam,
      bool iTookIDontKnowWhat) {
    String arePainkillerTaken = painKillerTaken == 1 ? "taken" : "notTaken";

    if (arePainkillerTaken == "taken") {
      _surveyeesRef.doc(_surveyId).update({
        'surveyAnswers.painkillersScreen.painkillerTaken': 'da',
        'surveyAnswers.painkillersScreen.paracetamol':
            paracetamol ? 'da' : FieldValue.delete(),
        'surveyAnswers.painkillersScreen.NSAR':
            NSAR ? 'da' : FieldValue.delete(),
        'surveyAnswers.painkillersScreen.tramadol':
            tramadol ? 'da' : FieldValue.delete(),
        'surveyAnswers.painkillersScreen.tramadolAndParacetamol':
            tramadolAndParacetamol ? 'da' : FieldValue.delete(),
        'surveyAnswers.painkillersScreen.tramadolAndDeksketoprofen':
            tramadolAndDeksketoprofen ? 'da' : FieldValue.delete(),
        'surveyAnswers.painkillersScreen.diazepam':
            diazepam ? 'da' : FieldValue.delete(),
        'surveyAnswers.painkillersScreen.iTookIDontKnowWhat':
            iTookIDontKnowWhat ? 'da' : FieldValue.delete(),
      });
    } else if (arePainkillerTaken == "notTaken") {
      _surveyeesRef.doc(_surveyId).update({
        'surveyAnswers.painkillersScreen.painkillerTaken': 'ne',
        'surveyAnswers.painkillersScreen.paracetamol': FieldValue.delete(),
        'surveyAnswers.painkillersScreen.NSAR': FieldValue.delete(),
        'surveyAnswers.painkillersScreen.tramadol': FieldValue.delete(),
        'surveyAnswers.painkillersScreen.tramadolAndParacetamol':
            FieldValue.delete(),
        'surveyAnswers.painkillersScreen.tramadolAndDeksketoprofen':
            FieldValue.delete(),
        'surveyAnswers.painkillersScreen.diazepam': FieldValue.delete(),
        'surveyAnswers.painkillersScreen.iTookIDontKnowWhat':
            FieldValue.delete(),
      });
    }
  }

  void updateGelPuttenOn(int gelPuttenOn) {
    _surveyeesRef.doc(_surveyId).update({
      'surveyAnswers.gelScreen.gelPuttenOn': gelPuttenOn == 1 ? 'da' : 'ne',
    });
  }

  void updateWorkout(
      int didWorkout, String notWorkoutReason, String reasonWhyNot) {
    String didTheyWorkout = didWorkout == 1 ? "yes" : "no";
    String didTheySayWhy = notWorkoutReason == "ostalo" ? "yes" : "no";

    if (didTheyWorkout == "yes") {
      _surveyeesRef.doc(_surveyId).update({
        'surveyAnswers.workoutScreen.workout': 'da',
        'surveyAnswers.workoutScreen.notWorkoutReason': FieldValue.delete()
      });
    } else if (didTheyWorkout == "no") {
      if (didTheySayWhy == "yes") {
        _surveyeesRef.doc(_surveyId).update({
          'surveyAnswers.workoutScreen.workout': 'ne',
          'surveyAnswers.workoutScreen.notWorkoutReason': notWorkoutReason,
          'surveyAnswers.workoutScreen.reasonWhy': reasonWhyNot
        });
      } else {
        _surveyeesRef.doc(_surveyId).update({
          'surveyAnswers.workoutScreen.workout': 'ne',
          'surveyAnswers.workoutScreen.notWorkoutReason': notWorkoutReason
        });
      }
    }
  }*/
}
