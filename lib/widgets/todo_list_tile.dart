import 'package:flutter/material.dart';
import 'package:hellosupa/extensions/date_time.ext.dart';
import 'package:hellosupa/models/todo.dart';
import 'package:hellosupa/pages/create.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id.toString()),
      onDismissed: (dir) async {
        if (dir == DismissDirection.endToStart) {
          await Supabase.instance.client
              .from("todos")
              .delete()
              .match({"id": todo.id});
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: ListTile(
            title: Text(todo.title),
            isThreeLine: true,
            subtitle: Text(todo.createdAt.formattedDateTime),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return CreatePage(
                  todo: todo,
                );
              }));
            },
          ),
        ),
      ),
    );
  }
}
