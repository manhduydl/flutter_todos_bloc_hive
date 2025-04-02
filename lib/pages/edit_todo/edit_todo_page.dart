import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_bloc_hive/constants/strings.dart';
import 'package:flutter_todos_bloc_hive/pages/edit_todo/widgets/due_date_picker.dart';
import 'package:flutter_todos_bloc_hive/pages/edit_todo/widgets/todo_title_field.dart';
import 'package:flutter_todos_bloc_hive/repository/todos_repository.dart';

import '../../models/todo.dart';
import 'bloc/edit_todo_bloc.dart';

class EditTodoPage extends StatelessWidget {
  const EditTodoPage({super.key, this.originTodo});

  final Todo? originTodo;

  static Route<bool> route({Todo? initialTodo}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => EditTodoBloc(
          todosRepository: context.read<TodosRepository>(),
          initialTodo: initialTodo,
        ),
        child: EditTodoPage(originTodo: initialTodo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditTodoBloc, EditTodoState>(
      listenWhen: (previous, current) => previous.status != current.status && current.status == EditTodoStatus.success,
      listener: (context, state) => {Navigator.of(context).pop(true)},
      child: EditTodoView(originTodo: originTodo),
    );
  }
}

class EditTodoView extends StatefulWidget {
  const EditTodoView({super.key, this.originTodo});

  final Todo? originTodo;

  @override
  State<EditTodoView> createState() => _EditTodoViewState();
}

class _EditTodoViewState extends State<EditTodoView> {
  // Form Key
  final _formKey = GlobalKey<FormState>();

  // Keep track title input text
  String _title = '';

  bool _isCurrentSnackBarVisible = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_isSameOriginTodo()) {
        if (_isCurrentSnackBarVisible) {
          return;
        }
        _isCurrentSnackBarVisible = true;
        ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(
                content: Center(
                    child: Text(
                  AppString.noChangeWarning,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 2),
              ),
            )
            .closed
            .then((value) => _isCurrentSnackBarVisible = false);
        return;
      }
      context.read<EditTodoBloc>().add(EditTodoSubmitted());
    }
  }

  bool _isSameOriginTodo() {
    final originTodo = widget.originTodo;
    final dueDate = context.read<EditTodoBloc>().state.dueDate;
    return originTodo != null && originTodo.title == _title && originTodo.dueDate == dueDate;
  }

  @override
  Widget build(BuildContext context) {
    final status = context.select((EditTodoBloc bloc) => bloc.state.status);
    final isNewTodo = context.select(
      (EditTodoBloc bloc) => bloc.state.isNewTodo,
    );
    _title = context.read<EditTodoBloc>().state.title; // Set first value for case editing

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          isNewTodo ? AppString.addTodoString : AppString.editTodoString,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
          child: Column(
            children: [
              TodoTitleField(onChanged: (text) {
                setState(() {
                  _title = text;
                });
                context.read<EditTodoBloc>().add(EditTodoTitleChanged(text));
              }),
              SizedBox(height: 20),
              DueDatePicker(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: (_title.trim().isNotEmpty && !status.isLoadingOrSuccess) ? _submit : null,
                child: status.isLoadingOrSuccess
                    ? CircularProgressIndicator()
                    : Text(
                        AppString.titleSubmitButton,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
