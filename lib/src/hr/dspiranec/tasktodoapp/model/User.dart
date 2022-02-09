class User {
  String id;
  String code;
  int inactiveDays;
  String status;
  String role;
  DateTime createdAt;

  User(this.id, this.code, this.inactiveDays, this.role, this.createdAt, this.status);

  User.fromJson(Map<String, dynamic> json, String id)
      : this.id = id,
        this.code = json['code'],
        this.inactiveDays = json['inactiveDays'],
        this.role = json['role'],
        this.createdAt = json['createdAt'].toDate(),
        this.status = json['status'];

  @override
  String toString() {
    return 'User{id: $id, code: $code, inactiveDays: $inactiveDays, status: $status, role: $role, createdAt: $createdAt}';
  }
}
