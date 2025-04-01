part of 'edit_todo_bloc.dart';

enum EditTodoStatus { initial, loading, success, failure }

extension EditTodoStatusX on EditTodoStatus {
  bool get isLoadingOrSuccess => [
        EditTodoStatus.loading,
        EditTodoStatus.success,
      ].contains(this);
}

final class EditTodoState extends Equatable {
  const EditTodoState({
    this.status = EditTodoStatus.initial,
    this.initialTodo,
    this.title = '',
    this.note = '',
    this.dueDate,
  });

  final EditTodoStatus status;
  final Task? initialTodo;
  final String title;
  final String note;
  final DateTime? dueDate;

  bool get isNewTodo => initialTodo == null;

  EditTodoState copyWith({
    EditTodoStatus? status,
    Task? initialTodo,
    String? title,
    String? note,
    DateTime? dueDate,
  }) {
    return EditTodoState(
      status: status ?? this.status,
      initialTodo: initialTodo ?? this.initialTodo,
      title: title ?? this.title,
      note: note ?? this.note,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  List<Object?> get props => [status, initialTodo, title, note, dueDate];
}
