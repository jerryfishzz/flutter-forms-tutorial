import 'package:flutter/material.dart';
import 'package:flutter_forms_files/models/todo.dart';
import 'package:flutter_forms_files/todo_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formGlobalKey = GlobalKey<FormState>();

  Priority _selectedPriority = Priority.low;
  String _title = '';
  String _description = '';

  final List<Todo> todos = [
    const Todo(
        title: 'Buy milk',
        description: 'There is no milk left in the fridge!',
        priority: Priority.high),
    const Todo(
        title: 'Make the bed',
        description: 'Keep things tidy please..',
        priority: Priority.low),
    const Todo(
        title: 'Pay bills',
        description: 'The gas bill needs paying ASAP.',
        priority: Priority.urgent),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: TodoList(todos: todos)),

            // form stuff below here
            Form(
              key: _formGlobalKey, // form key, needed for validation
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // todo title
                  TextFormField(
                    maxLength: 20,
                    decoration: const InputDecoration(
                      label: Text('Todo title'),
                    ),
                    validator: (value) {
                      // isEmpty means ''. Any blank space(s) (' ') is not empty.
                      if (value == null || value.isEmpty) {
                        return 'You must enter a value for the title';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _title =
                          value!; // value is never null thanks to the validator
                    },
                  ),

                  // todo description
                  TextFormField(
                    maxLength: 40,
                    decoration: const InputDecoration(
                      label: Text('Todo description'),
                    ),
                    validator: (value) {
                      // isEmpty means ''. Any blank space(s) (' ') is not empty.
                      if (value == null || value.isEmpty || value.length < 5) {
                        return 'Enter a description as least 5 characters long';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _description =
                          value!; // value is never null thanks to the validator
                    },
                  ),

                  // todo priority
                  DropdownButtonFormField<Priority>(
                    value: _selectedPriority, // (initial) value
                    decoration: const InputDecoration(
                      label: Text('Priority of todo'),
                    ),
                    items: Priority.values
                        .map((priority) => DropdownMenuItem(
                              value: priority,
                              child: Text(priority.title),
                            ))
                        .toList(),
                    onChanged: (value) => {
                      setState(() {
                        _selectedPriority = value!;
                      })
                    },
                  ),

                  // submit button
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      if (_formGlobalKey.currentState!.validate()) {
                        _formGlobalKey.currentState!.save();

                        final newTodo = Todo(
                          title: _title,
                          description: _description,
                          priority: _selectedPriority,
                        );

                        setState(() {
                          // Looks like no immutable necessary here
                          todos.add(newTodo);
                        });
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
