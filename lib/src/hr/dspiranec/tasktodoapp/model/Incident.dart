class Incident {
  String id;
  String userCode;
  String userId;
  String reason;
  String reasonWhyElse;
  DateTime createdAt;


  Incident(this.id, this.userCode, this.userId, this.reason, this.reasonWhyElse,
      this.createdAt);

  Incident.fromJson(Map<String, dynamic> json, String id)
      : this.id = id,
        this.userCode = json['userCode'],
        this.userId = json['userId'],
        this.reason = json['reason'],
        this.reasonWhyElse = json['reasonWhyElse'],
        this.createdAt = json['createdAt'].toDate();

  @override
  String toString() {
    return 'Incident{id: $id, userCode: $userCode, userId: $userId, reason: $reason, reasonWhyElse: $reasonWhyElse, createdAt: $createdAt}';
  }
}
