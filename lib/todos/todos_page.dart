import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_bloc_hive/constants/colors.dart';
import 'package:flutter_todos_bloc_hive/todos/bloc/todos_bloc.dart';
import 'package:flutter_todos_bloc_hive/todos/widgets/todo_list_tile.dart';

import '../edit_todo/edit_todo_page.dart';
import '../models/todo.dart';
import '../services/todos_api.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosBloc(todosApi: context.read<TodosApi>())..add(TodosInitEvent()),
      child: const TodosView(),
    );
  }
}

class TodosView extends StatelessWidget {
  const TodosView({super.key});

  void _showEditTodoPage(BuildContext context, Todo? todo) async {
    final bool? result = await Navigator.of(context).push<bool>(EditTodoPage.route(initialTodo: todo));
    if (result == true && context.mounted) {
      context.read<TodosBloc>().add(LoadTodosEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocListener<TodosBloc, TodosState>(
        listener: (context, state) {
          // print(state);
          if (state.shouldRemindTodo) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Reminder"),
                content: const Text('Task due date today'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        child: BlocBuilder<TodosBloc, TodosState>(
          builder: (context, state) {
            if (state.todos.isEmpty) {
              if (state.status == TodosStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.status != TodosStatus.success) {
                return const SizedBox.shrink();
              } else {
                return _EmptyWidget();
              }
            }
            return Scrollbar(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  children: <Widget>[
                    _SearchBox(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.filteredTodos.length,
                        itemBuilder: (_, index) {
                          final todo = state.filteredTodos.elementAt(index);
                          return TodoListTile(
                            todo: todo,
                            onToggleCompleted: (isCompleted) {
                              context.read<TodosBloc>().add(TodoCompletionToggled(
                                    todo: todo,
                                    isCompleted: isCompleted,
                                  ));
                            },
                            onDismissed: (_) {
                              context.read<TodosBloc>().add(TodoDeleted(todo));
                            },
                            onTap: () => _showEditTodoPage(context, todo),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => _showEditTodoPage(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}

/*
 * Empty widget
 */
class _EmptyWidget extends StatelessWidget {
  const _EmptyWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          const Text(
            "No Content Available",
            style: TextStyle(fontSize: 20),
          ),
          ElevatedButton(
            onPressed: () => context.read<TodosBloc>().add(LoadTodosEvent()),
            child: const Text("Refresh"),
          ),
        ],
      ),
    );
  }
}

/*
 * Search box widget
 */
class _SearchBox extends StatefulWidget {
  const _SearchBox({super.key});

  @override
  State<_SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<_SearchBox> {
  Timer? _debounce;

  void _onSearchChanged(BuildContext context, String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<TodosBloc>().add(TodosSearchQueryChanged(query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [
        BoxShadow(
          color: AppColors.shadowColor,
          blurRadius: 24,
          spreadRadius: 0,
          offset: Offset(0, 8),
        ),
      ]),
      child: TextField(
        onChanged: (value) => _onSearchChanged(context, value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
