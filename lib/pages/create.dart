import 'package:flutter/material.dart';
import 'package:hellosupa/models/todo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key, this.todo});
  final Todo? todo;

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final textController = TextEditingController();
  String get title => textController.text.trim();
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    textController.text = widget.todo?.title ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLines: 4,
                validator: (val) =>
                    (val?.isEmpty ?? false) ? "notes is required" : null,
                controller: textController,
                decoration: const InputDecoration(
                  hintText: "Write something here...",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    if (_formKey.currentState?.validate() ?? false) {
                      _isLoading = true;
                      setState(() {});
                      final userID =
                          Supabase.instance.client.auth.currentUser?.id;

                      if (widget.todo == null) {
                        await Supabase.instance.client.from("todos").insert({
                          "title": title,
                          "user_id": userID,
                        });
                      } else {
                        await Supabase.instance.client.from("todos").update({
                          "title": title,
                        }).match({"id": widget.todo!.id});
                      }

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  } catch (e) {
                    debugPrint(e.toString());
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
