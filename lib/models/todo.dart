class Todo {
  final int id;
  final String title;
  final DateTime createdAt;

  Todo(this.id, this.title, this.createdAt);

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      map['id'],
      map['title'] as String,
      DateTime.parse(map['created_at']),
    );
  }
}
