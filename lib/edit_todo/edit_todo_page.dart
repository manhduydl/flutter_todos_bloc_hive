import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_bloc_hive/services/todos_api.dart';

import '../models/task.dart';
import '../utils/date_util.dart';
import 'bloc/edit_todo_bloc.dart';

class EditTodoPage extends StatelessWidget {
  const EditTodoPage({super.key});

  static Route<bool> route({Task? initialTodo}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => EditTodoBloc(
          todosRepository: context.read<TodosApi>(),
          initialTodo: initialTodo,
        ),
        child: const EditTodoPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditTodoBloc, EditTodoState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditTodoStatus.success,
      listener: (context, state) => Navigator.of(context).pop(true),
      child: const EditTodoView(),
    );
  }
}

class EditTodoView extends StatelessWidget {
  const EditTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((EditTodoBloc bloc) => bloc.state.status);
    final isNewTodo = context.select(
      (EditTodoBloc bloc) => bloc.state.isNewTodo,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewTodo ? "Add new todo" : "Edit todo",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        onPressed: status.isLoadingOrSuccess
            ? null
            : () => context.read<EditTodoBloc>().add(const EditTodoSubmitted()),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: const CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _TitleField(),
                _DescriptionField(),
                _DueDateSelection()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DueDateSelection extends StatelessWidget {
  const _DueDateSelection({super.key});

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      if (context.mounted) {
        context.read<EditTodoBloc>().add(EditTodoDueDateChanged(picked));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTodoBloc, EditTodoState>(
      builder: (context, state) {
        return ListTile(
          leading: Icon(Icons.calendar_today),
          title: Text("Due Date"),
          subtitle: Text(showDate(state.dueDate)),
          onTap: () {
            _selectDate(context);
          },
        );
      },
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditTodoBloc>().state;
    final hintText = state.initialTodo?.title ?? '';

    return TextFormField(
      key: const Key('editTodoView_title_textFormField'),
      initialValue: state.title,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: "Title",
        hintText: hintText,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onChanged: (value) {
        context.read<EditTodoBloc>().add(EditTodoTitleChanged(value));
      },
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditTodoBloc>().state;
    final hintText = state.initialTodo?.note ?? '';

    return TextFormField(
      key: const Key('editTodoView_description_textFormField'),
      initialValue: state.note,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: "Note",
        hintText: hintText,
      ),
      maxLength: 300,
      maxLines: 7,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (value) {
        context.read<EditTodoBloc>().add(EditTodoDescriptionChanged(value));
      },
    );
  }
}
