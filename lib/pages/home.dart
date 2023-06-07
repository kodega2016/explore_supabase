import 'package:flutter/material.dart';
import 'package:hellosupa/models/todo.dart';
import 'package:hellosupa/pages/create.dart';
import 'package:hellosupa/widgets/todo_list_tile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  getData() async {
    final client = Supabase.instance.client.from("todos");
    final rows = await client.select().eq(
          "user_id",
          Supabase.instance.client.auth.currentUser?.id,
        );
    return (rows as List<dynamic>).map((e) => Todo.fromMap(e)).toList();
  }

  watchData() {
    final client = Supabase.instance.client.from("todos");
    final rows = client.stream(primaryKey: ["id"]).eq(
      "user_id",
      Supabase.instance.client.auth.currentUser?.id,
    );
    return rows.map((event) => event.map((e) => Todo.fromMap(e)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const CreatePage(),
            fullscreenDialog: true,
          ));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
            icon: const Icon(Icons.exit_to_app_outlined),
          )
        ],
      ),
      body: StreamBuilder(
        stream: watchData(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.connectionState == ConnectionState.done ||
              snap.connectionState == ConnectionState.active) {
            final todos = snap.data as List<Todo>;
            return todos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.emoji_emotions_outlined,
                          size: 60,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("No any todos found."),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: todos.length,
                    itemBuilder: (context, i) {
                      final todo = todos[i];
                      return TodoTile(todo: todo);
                    },
                  );
          }
          return Container();
        },
      ),
    );
  }
}
