import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_bloc_hive/todos/bloc/todos_bloc.dart';

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
              return Center(
                child: Text("${state.tasks}"),
              );
            }
            return const Center(child: CupertinoActivityIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => {print("Add todo")},
        child: const Icon(Icons.add),
      ),
    );
  }
}
