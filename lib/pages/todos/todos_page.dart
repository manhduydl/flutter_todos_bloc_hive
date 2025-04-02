import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_todos_bloc_hive/constants/strings.dart';
import 'package:flutter_todos_bloc_hive/pages/todos/widgets/empty.dart';
import 'package:flutter_todos_bloc_hive/pages/todos/widgets/search_box.dart';
import 'package:flutter_todos_bloc_hive/pages/todos/widgets/todo_list_tile.dart';
import 'package:flutter_todos_bloc_hive/repository/todos_repository.dart';

import '../../models/todo.dart';
import '../edit_todo/edit_todo_page.dart';
import 'bloc/todos_bloc.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosBloc(todosRepository: context.read<TodosRepository>())..add(TodosInitEvent()),
      child: const TodosView(),
    );
  }
}

class TodosView extends StatefulWidget {
  const TodosView({super.key});

  @override
  State<TodosView> createState() => _TodosViewState();
}

class _TodosViewState extends State<TodosView> {
  late StreamSubscription _subscription;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Adding listener to app foreground/background
    _subscription = FGBGEvents.instance.stream.listen(_onData);
    // Adding listener to scroll controller
    _scrollController.addListener(_onScroll);
  }

  void _onData(FGBGType type) {
    // When app become foreground, reminder check will be called
    if (type == FGBGType.foreground) {
      context.read<TodosBloc>().add(TodosReminderCheck());
    }
  }

  void _onScroll() {
    // When the list is scrolled, release focus the search box
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  void dispose() {
    _subscription.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Private method

  void _pushEditTodoPage(BuildContext context, Todo? todo) async {
    final bool? result = await Navigator.of(context).push<bool>(EditTodoPage.route(initialTodo: todo));
    if (result == true && context.mounted) {
      context.read<TodosBloc>().add(LoadTodosEvent());
    }
  }

  void _showReminderDialog(BuildContext context) {
    final state = context.read<TodosBloc>().state;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppString.reminderTitle),
        content: Text('${state.numTodosDueToday} ${AppString.reminderMessage}'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    ).then(
      (value) => {
        if (context.mounted) {context.read<TodosBloc>().add(TodosFinishRemind())}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TodosBloc, TodosState>(
            listener: (context, state) {
              if (state.shouldRemindTodo) {
                _showReminderDialog(context);
              }
            },
          ),
          BlocListener<TodosBloc, TodosState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if (state.status == TodosStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(AppString.loadTodosError),
                    ),
                  );
              }
            },
          ),
        ],
        child: BlocBuilder<TodosBloc, TodosState>(
          builder: (context, state) {
            if (state.todos.isEmpty) {
              if (state.status == TodosStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.status != TodosStatus.success) {
                return const SizedBox.shrink();
              } else {
                return EmptyWidget();
              }
            }
            return GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  children: <Widget>[
                    SearchBox(),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: state.filteredTodos.length,
                        itemBuilder: (_, index) {
                          final todo = state.filteredTodos.elementAt(index);
                          return TodoListTile(
                            todo: todo,
                            onToggleCompleted: (isCompleted) {
                              context.read<TodosBloc>().add(
                                    TodoCompletionToggled(
                                      todo: todo,
                                      isCompleted: isCompleted,
                                    ),
                                  );
                            },
                            onDismissed: (_) {
                              context.read<TodosBloc>().add(TodoDeleted(todo));
                            },
                            onTap: () => _pushEditTodoPage(context, todo),
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
        onPressed: () => _pushEditTodoPage(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
