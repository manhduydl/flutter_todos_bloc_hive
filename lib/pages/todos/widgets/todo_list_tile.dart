import 'package:flutter/material.dart';
import 'package:flutter_todos_bloc_hive/constants/colors.dart';
import 'package:flutter_todos_bloc_hive/models/todo.dart';

import '../../../utils/date_util.dart';

class TodoListTile extends StatelessWidget {
  const TodoListTile({
    required this.todo,
    super.key,
    this.onToggleCompleted,
    this.onDismissed,
    this.onTap,
  });

  final Todo todo;
  final ValueChanged<bool>? onToggleCompleted;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;

  bool _todoIsOverdue() {
    if (todo.isCompleted) {
      return false;
    }
    return todo.dueDate != null && DateTime.now().isAfter(todo.dueDate!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key('todoListTile_${todo.id}'),
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 20),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: const Icon(
          Icons.delete,
          color: Color(0xAAFFFFFF),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          elevation: 2,
          shadowColor: AppColors.shadowColor,
          child: ListTile(
            onTap: onTap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            tileColor: Colors.white,
            leading: Checkbox(
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              value: todo.isCompleted,
              onChanged: onToggleCompleted == null ? null : (value) => onToggleCompleted!(value!),
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              showDate(todo.dueDate),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: _todoIsOverdue() ? Colors.red : Colors.grey,
              ),
            ),
            trailing: onTap == null ? null : const Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}
