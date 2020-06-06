part of 'todos_bloc.dart';

abstract class TodosEvent extends Equatable {
  const TodosEvent();
  @override
  List<Object> get props => [];
}

class LoadTodos extends TodosEvent{}

class TodosLoadSuccessful extends TodosEvent{
  final List<Todo> todos;
  TodosLoadSuccessful({this.todos});
  @override
  List<Object> get props => [todos];
}

class TodoAdded extends TodosEvent{
  final Todo todo;
  TodoAdded({this.todo});
  @override
  List<Object> get props => [todo];
}

class TodoUpdated extends TodosEvent{
  final Todo updatedTodo;
  TodoUpdated({this.updatedTodo});
  @override
  List<Object> get props => [updatedTodo];
}

class TodoDeleted extends TodosEvent{
  final Todo todo;
  TodoDeleted({this.todo});
  @override
  List<Object> get props => [todo];
}

class ClearCompleted extends TodosEvent{}

class ToggleAll extends TodosEvent{}