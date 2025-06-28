import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/todo_cubit.dart';
import '../../cubit/todo_state.dart';

class TodoPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'Todo title'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      context.read<TodoCubit>().createTodo(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TodoCubit, TodoState>(
              builder: (context, state) {
                if (state is TodoLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TodoError) {
                  return Center(
                    child: Column(
                      children: [
                        Text(state.exception.toString()),
                        ElevatedButton(
                          onPressed: () {
                            context.read<TodoCubit>().loadTodos();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is TodoLoaded) {
                  return ListView.builder(
                    itemCount: state.todos.length,
                    itemBuilder: (context, index) {
                      final todo = state.todos[index];
                      return ListTile(
                        title: Text(todo.title),
                        leading: Checkbox(
                          value: todo.completed,
                          onChanged: (_) {
                            context.read<TodoCubit>().toggleTodoCompletion(
                              todo.id,
                              todo.completed,
                            );
                          },
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text('No todos yet'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
