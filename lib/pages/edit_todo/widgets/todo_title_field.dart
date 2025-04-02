import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/strings.dart';
import '../bloc/edit_todo_bloc.dart';

class TodoTitleField extends StatelessWidget {
  const TodoTitleField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditTodoBloc>().state;
    final OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    );

    return TextFormField(
      autofocus: true,
      textInputAction: TextInputAction.done,
      initialValue: state.title,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: AppString.titleOfTodo,
        border: borderStyle,
        enabledBorder: borderStyle,
        disabledBorder: borderStyle,
        focusedBorder: borderStyle,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 1),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onChanged: onChanged,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return AppString.emptyTextError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
