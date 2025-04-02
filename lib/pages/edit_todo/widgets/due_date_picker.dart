import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/strings.dart';
import '../../../utils/date_util.dart';
import '../bloc/edit_todo_bloc.dart';

class DueDatePicker extends StatelessWidget {
  const DueDatePicker({super.key});

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: context.read<EditTodoBloc>().state.dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && context.mounted) {
      context.read<EditTodoBloc>().add(EditTodoDueDateChanged(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return BlocBuilder<EditTodoBloc, EditTodoState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => {
            FocusScope.of(context).requestFocus(FocusNode()),
            _selectDate(context),
          },
          child: Container(
            // margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(AppString.dueDateString, style: textTheme.titleMedium),
                ),
                Expanded(child: Container()),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  height: 35,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey.shade100),
                  child: Center(
                    child: Text(
                      showDate(state.dueDate, placeholder: "Select Date"),
                      style: textTheme.titleMedium,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
