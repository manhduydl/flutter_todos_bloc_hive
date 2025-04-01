import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_bloc_hive/todos/bloc/todos_bloc.dart';
import 'package:flutter_todos_bloc_hive/todos/widgets/todo_list_tile.dart';

import '../edit_todo/edit_todo_page.dart';
import '../services/todos_api.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TodosBloc(context.read<TodosApi>())..add(LoadTodosEvent()),
      child: const TodosView(),
    );
  }
}

class TodosView extends StatelessWidget {
  const TodosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos"),
        backgroundColor: Colors.blue,
      ),
      body: BlocListener<TodosBloc, TodosState>(
        listener: (context, state) {
          print(state);
        },
        child: BlocBuilder<TodosBloc, TodosState>(
          builder: (context, state) {
            if (state is TodosLoadedState) {
              if (state.tasks.isEmpty) {
                return const Center(
                  child: Text("No tasks"),
                );
              }
              // return Center(
              //   child: Text("${state.tasks}"),
              // );
              return CupertinoScrollbar(
                child: ListView.builder(
                  itemCount: state.tasks.length,
                  itemBuilder: (_, index) {
                    final task = state.tasks.elementAt(index);
                    return TodoListTile(
                      task: task,
                      onToggleCompleted: (isCompleted) {
                        // context.read<TodosBloc>().add(
                        //   TodosOverviewTodoCompletionToggled(
                        //     todo: todo,
                        //     isCompleted: isCompleted,
                        //   ),
                        // );
                        print("task toggle");
                      },
                      onDismissed: (_) {
                        // context
                        //     .read<TodosOverviewBloc>()
                        //     .add(TodosOverviewTodoDeleted(todo));
                      },
                      onTap: () {
                        Navigator.of(context).push(
                          EditTodoPage.route(initialTodo: task),
                        );
                      },
                    );
                  },
                ),
              );
            }
            return const Center(child: CupertinoActivityIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => {
          print("Add todo"),
          Navigator.of(context).push(
            EditTodoPage.route(initialTodo: null),
          ),
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
