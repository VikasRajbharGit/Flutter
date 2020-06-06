part of 'todos_bloc.dart';

abstract class TodosState extends Equatable {
  const TodosState();
  @override
  List<Object> get props => [];
}

class TodosLoading extends TodosState {}

class TodosLoaded extends TodosState {
  final List<Todo> todos;
  TodosLoaded({this.todos});
  @override
  List<Object> get props => [todos];
}

class TodosError extends TodosState {
  final String error;
  TodosError({this.error});
  @override
  List<Object> get props => [error];
}

class AlterTodoSuccess extends TodosState{
  String msg;
  AlterTodoSuccess({this.msg});
  @override
  List<Object> get props => [msg];
}

class AlterTodoFail extends TodosState{
  String msg;
  AlterTodoFail({this.msg});
  @override
  List<Object> get props => [msg];
}
