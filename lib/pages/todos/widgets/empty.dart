import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todos_bloc.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

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
