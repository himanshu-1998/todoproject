import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:todoproject/model/todo.dart';
import 'package:todoproject/page/detail_page.dart';

import '../provider/todos.dart';
import '../utils.dart';

class TodoWidget extends StatefulWidget {
  final Todo todo;

  const TodoWidget({
    required this.todo,
    Key? key,
  }) : super(key: key);

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  bool strikeThrough = false;

  @override
  Widget build(BuildContext context) => buildTodo(context);

  Widget buildTodo(BuildContext context) => GestureDetector(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Checkbox(
                activeColor: Theme.of(context).errorColor,
                checkColor: Colors.white,
                value: strikeThrough,
                onChanged: (_) {
                  setState(() {
                    strikeThrough = !strikeThrough;
                  });
                  final provider =
                      Provider.of<TodosProvider>(context, listen: false);

                  /* Utils.showSnackBar(
                      context,
                      isDone ? 'Task completed' : 'Task marked incomplete',
                    );*/
                },
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.todo.title,
                      style: TextStyle(
                        decoration:
                            strikeThrough ? TextDecoration.lineThrough : null,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                      ),
                    ),
                    if (widget.todo.description.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        child: Text(
                          widget.todo.description,
                          style: TextStyle(
                              decoration: strikeThrough
                                  ? TextDecoration.lineThrough
                                  : null,
                              fontSize: 20,
                              height: 1.5),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailsScreen(
                      title: widget.todo.title,
                      description: widget.todo.description,
                    )),
          );
        },
      );

  void deleteTodo(BuildContext context, Todo todo) {
    final provider = Provider.of<TodosProvider>(context, listen: false);
    provider.removeTodo(todo);
  }
}
