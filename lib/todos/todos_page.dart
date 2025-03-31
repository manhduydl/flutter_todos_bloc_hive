import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_bloc_hive/todos/bloc/todos_bloc.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosBloc(),
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
      body: Center(
        child: Text("Todos"),
      ),
    );
  }
}
