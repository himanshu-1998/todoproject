import 'package:flutter/material.dart';
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

              return Dismissible(
                  key: Key(provider.todos[index].toString()),
                  onDismissed: (direction) {
                    setState(() {
                      provider.removeTodo(todo);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    child: Center(
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                  ),
                  child: TodoWidget(todo: todo));
            },
          );
  }
}
