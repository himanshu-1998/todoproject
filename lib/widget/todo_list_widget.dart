import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todoproject/widget/todo_widget.dart';

import '../provider/todos.dart';

class TodoListWidget extends StatefulWidget {
  @override
  State<TodoListWidget> createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context);
    final todos = provider.todos;

    return todos.isEmpty
        ? const Center(
            child: Text(
              'No todos.',
              style: TextStyle(fontSize: 20),
            ),
          )
        : ListView.separated(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(16),
            separatorBuilder: (context, index) => Container(height: 8),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              return Slidable(
                  key: ValueKey(index),
                  startActionPane: ActionPane(
                    dismissible: DismissiblePane(
                      onDismissed: () {
                        setState(() {
                          provider.removeTodo(todo);
                        });
                      },
                    ),
                    motion: BehindMotion(),
                    children: [
                      SlidableAction(
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          onPressed: (context) {
                            setState(() {});
                          })
                    ],
                  ),
                  endActionPane: ActionPane(
                    dismissible: DismissiblePane(
                      onDismissed: () {
                        setState(() {
                          provider.removeTodo(todo);
                        });
                      },
                    ),
                    motion: BehindMotion(),
                    children: [
                      SlidableAction(
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          onPressed: (context) {
                            setState(() {
                              provider.removeTodo(todo);
                            });
                          })
                    ],
                  ),
                  child: TodoWidget(todo: todo));
            },
          );
  }
}
