import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/model/Incident.dart';
import 'package:task_todo_app/src/hr/dspiranec/tasktodoapp/model/User.dart';

import 'UserService.dart';

class IncidentService {
  final CollectionReference incidentsRef =
  FirebaseFirestore.instance.collection("incidents");

  Future<List<Incident>> getAllIncidentsOrderedByCreatedAt() async {
    QuerySnapshot qSnapshot =
    await incidentsRef.orderBy('createdAt', descending: true).get();
    List<QueryDocumentSnapshot> incidentDocs = qSnapshot.docs;
    List<Incident> incidents = [];
    incidentDocs
        .forEach((incident) => {incidents.add(Incident.fromJson(incident.data(), incident.id))});

    return incidents;
  }

  addUnwantedEvent(String userId, String reason, String reasonWhyElse) async {
    User user = await UserService().getUserById(userId);

    if (reasonWhyElse == null) {
      await incidentsRef.add({
        "userId": user.id,
        "userCode": user.code,
        "createdAt": Timestamp.now(),
        "reason": reason
      });
    }
    else {
      await incidentsRef.add({
        "userId": user.id,
        "userCode": user.code,
        "createdAt": Timestamp.now(),
        "reason": reason,
        "reasonWhyElse": reasonWhyElse
      });
    }
  }
}