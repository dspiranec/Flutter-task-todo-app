import 'package:timelines/timelines.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/logic/service/IncidentService.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/model/Incident.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/view/widgets/common/DataNotFound.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart';

class UnwantedEventsScreen extends StatefulWidget {
  @override
  _UnwantedEventsScreenState createState() => _UnwantedEventsScreenState();
}

class _UnwantedEventsScreenState extends State<UnwantedEventsScreen> {
  List<Incident> _incidents;
  bool _unwantedEventsDataIsEmpty = false;
  var formatter = new DateFormat('dd.MM.yyyy.');

  @override
  void initState() {
    super.initState();
    _setupTimezone();
    _getAllUnwantedEvents();
  }

  _setupTimezone() {
    initializeTimeZones();
    setLocalLocation(getLocation("Europe/Zagreb"));
  }

  _getAllUnwantedEvents() async {
    List incidents =
        await IncidentService().getAllIncidentsOrderedByCreatedAt();

    setState(() {
      _incidents = incidents;
      if (incidents.isEmpty)
        _unwantedEventsDataIsEmpty = true;
      else
        _unwantedEventsDataIsEmpty = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              tr("AdminHome.dogadajiNaslov"),
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
            Expanded(
                flex: 1,
                child: !_unwantedEventsDataIsEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            child: Expanded(
                              child: _incidents == null
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Timeline.tileBuilder(
                                      builder: TimelineTileBuilder.fromStyle(
                                        contentsAlign:
                                            ContentsAlign.alternating,
                                        itemCount: _incidents != null
                                            ? _incidents.length
                                            : 0,
                                        contentsBuilder: (context, index) {
                                          Incident incident = _incidents[index];
                                          var incidentDate = TZDateTime.from(
                                              incident.createdAt,
                                              getLocation('Europe/Zagreb'));

                                          String formattedTime =
                                              DateFormat('jm')
                                                  .format(incidentDate);
                                          String formattedDate =
                                              formatter.format(incidentDate);

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 45, bottom: 45),
                                            child: ListTile(
                                              title: Column(
                                                crossAxisAlignment: index % 2 != 0
                                                    ? CrossAxisAlignment.end
                                                    : CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    formattedDate +
                                                        "  " +
                                                        formattedTime,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        index % 2 != 0
                                                            ? MainAxisAlignment
                                                                .end
                                                            : MainAxisAlignment
                                                                .start,
                                                    children: [
                                                      Flexible(
                                                          child: Wrap(
                                                        children: [
                                                          Text(
                                                            "Šifra korisnika: ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                          Text(
                                                            incident.userCode,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                    ],
                                                  ),
                                                  Column(
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment: index %
                                                                    2 != 0
                                                            ? MainAxisAlignment
                                                                .end
                                                            : MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Flexible(
                                                            child: Wrap(
                                                              children: [
                                                                Text(
                                                                  "Razlog: " +
                                                                      incident
                                                                          .reason,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      incident.reasonWhyElse ==
                                                              null
                                                          ? SizedBox.shrink()
                                                          : Align(
                                                              alignment: index %
                                                                          2 != 0
                                                                  ? Alignment
                                                                      .centerRight
                                                                  : Alignment
                                                                      .centerLeft,
                                                              child: Text(
                                                                "Zašto: " +
                                                                    incident
                                                                        .reasonWhyElse,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                            )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      )
                    : DataNotFound(title: "Nema podataka")),
          ],
        ));
  }
}
