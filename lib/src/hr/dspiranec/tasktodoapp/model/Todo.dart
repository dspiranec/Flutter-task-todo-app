class Todo {
  String name;
  bool checked;

  Todo({this.name, this.checked});

  Todo.fromJson(Map<String, dynamic> json)
      : this.name = json['name'],
        this.checked = json['checked'];

  @override
  String toString() {
    return 'Todo{name: $name, checked: $checked}';
  }
}
